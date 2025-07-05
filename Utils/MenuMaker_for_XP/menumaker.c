#include <gtk/gtk.h>
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <string.h>
#include <dirent.h>

GtkWidget *icon_preview;
GtkWidget *listbox;
GtkWidget *test_button;
GtkWidget *make_button;

typedef struct {
    gchar name[256];
    gchar filename[512];
    gchar exec[512];
    gchar category[256];
} AppEntry;

GList *app_entries = NULL;

gboolean find_icon_file(const char *iconname, char *result_path, size_t maxlen) {
    const char *icon_dirs[] = {
        "/usr/share/icons/hicolor/48x48/apps/",
        "/usr/share/pixmaps/",
        "/usr/share/icons/hicolor/32x32/apps/",
        NULL
    };
    for (int i = 0; icon_dirs[i] != NULL; i++) {
        snprintf(result_path, maxlen, "%s%s.png", icon_dirs[i], iconname);
        if (g_file_test(result_path, G_FILE_TEST_EXISTS)) return TRUE;
        snprintf(result_path, maxlen, "%s%s.svg", icon_dirs[i], iconname);
        if (g_file_test(result_path, G_FILE_TEST_EXISTS)) return TRUE;
    }
    return FALSE;
}

void load_icon(const char *icon_name) {
    GdkPixbuf *pixbuf = NULL;
    char path[512];
    const char *icon_dirs[] = {
        "/usr/share/icons/hicolor/48x48/apps/",
        "/usr/share/pixmaps/",
        "/usr/share/icons/hicolor/32x32/apps/",
        NULL
    };
    for (int i = 0; icon_dirs[i] != NULL; i++) {
        snprintf(path, sizeof(path), "%s%s.png", icon_dirs[i], icon_name);
        if (g_file_test(path, G_FILE_TEST_EXISTS)) {
            pixbuf = gdk_pixbuf_new_from_file_at_size(path, 32, 32, NULL);
            break;
        }
        snprintf(path, sizeof(path), "%s%s.svg", icon_dirs[i], icon_name);
        if (g_file_test(path, G_FILE_TEST_EXISTS)) {
            pixbuf = gdk_pixbuf_new_from_file_at_size(path, 32, 32, NULL);
            break;
        }
    }
    if (pixbuf) {
        gtk_image_set_from_pixbuf(GTK_IMAGE(icon_preview), pixbuf);
        g_object_unref(pixbuf);
    } else {
        gtk_image_clear(GTK_IMAGE(icon_preview));
    }
}

void on_row_selected(GtkListBox *box, GtkListBoxRow *row, gpointer user_data) {
    gint index = gtk_list_box_row_get_index(row);
    AppEntry *entry = (AppEntry *)g_list_nth_data(app_entries, index);
    FILE *fp = fopen(entry->filename, "r");
    if (!fp) return;
    char line[512], iconname[256] = "", exec[512] = "";
    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, "Icon=", 5) == 0) sscanf(line + 5, "%s", iconname);
        if (strncmp(line, "Exec=", 5) == 0) sscanf(line + 5, "%s", exec);
    }
    fclose(fp);
    if (strlen(iconname) > 0) load_icon(iconname);
    if (strlen(exec) > 0) strncpy(entry->exec, exec, sizeof(entry->exec));
}

void on_test_button_clicked(GtkButton *button, gpointer user_data) {
    GtkListBoxRow *row = gtk_list_box_get_selected_row(GTK_LIST_BOX(listbox));
    if (!row) return;
    gint index = gtk_list_box_row_get_index(row);
    AppEntry *entry = (AppEntry *)g_list_nth_data(app_entries, index);
    if (strlen(entry->exec) > 0) {
        gchar *argv[] = {"/bin/sh", "-c", entry->exec, NULL};
        g_spawn_async(NULL, argv, NULL, G_SPAWN_DEFAULT, NULL, NULL, NULL, NULL);
    }
}

void on_make_button_clicked(GtkButton *button, gpointer user_data) {
    GtkListBoxRow *row = gtk_list_box_get_selected_row(GTK_LIST_BOX(listbox));
    if (!row) return;
    gint index = gtk_list_box_row_get_index(row);
    AppEntry *entry = (AppEntry *)g_list_nth_data(app_entries, index);
    if (!entry || strlen(entry->exec) == 0) return;
    FILE *fp = fopen(entry->filename, "r");
    if (!fp) return;
    char line[512], iconname[256] = "";
    while (fgets(line, sizeof(line), fp)) {
        if (strncmp(line, "Icon=", 5) == 0) {
            sscanf(line + 5, "%255[^\n]", iconname);
            break;
        }
    }
    fclose(fp);
    char icon_path[512];
    if (!find_icon_file(iconname, icon_path, sizeof(icon_path))) {
        GtkWidget *dialog = gtk_message_dialog_new(NULL, GTK_DIALOG_DESTROY_WITH_PARENT,
            GTK_MESSAGE_WARNING, GTK_BUTTONS_OK, "Icon not found — EXE generation canceled.");
        gtk_dialog_run(GTK_DIALOG(dialog));
        gtk_widget_destroy(dialog);
        return;
    }
    const char *home = getenv("HOME");
    char safe_name[256];
    gchar *base = g_path_get_basename(entry->exec);
    int j = 0;
    for (int i = 0; base[i] != '\0' && j < 255; i++) {
        if (g_ascii_isalnum(base[i]) || base[i] == '-' || base[i] == '_') {
            safe_name[j++] = base[i];
        }
    }
    safe_name[j] = '\0';
    g_free(base);
    char project_dir[512];
    snprintf(project_dir, sizeof(project_dir), "%s/MXP/xpstart/%s", home, safe_name);
    if (g_file_test(project_dir, G_FILE_TEST_IS_DIR)) {
        GDir *d = g_dir_open(project_dir, 0, NULL);
        const char *filename;
        while ((filename = g_dir_read_name(d)) != NULL) {
            char filepath[512];
            snprintf(filepath, sizeof(filepath), "%s/%s", project_dir, filename);
            remove(filepath);
        }
        g_dir_close(d);
    } else {
        g_mkdir_with_parents(project_dir, 0755);
    }
    char c_path[512];
    snprintf(c_path, sizeof(c_path), "%s/program.c", project_dir);
    fp = fopen(c_path, "w");
    if (!fp) return;
    fprintf(fp,
        "#include <process.h>\n#include <stdio.h>\n#include <stdlib.h>\n\n"
        "int main(void) {\n"
        "    const char *cmd = \"linsrarter.exe\";\n"
        "    const char *param = \"\\\"%s\\\"\";\n"
        "    char fullcmd[260];\n"
        "    snprintf(fullcmd, sizeof(fullcmd), \"%%s %%s\", cmd, param);\n"
        "    system(fullcmd);\n    return 0;\n}\n", entry->exec);
    fclose(fp);
    char rc_path[512];
    snprintf(rc_path, sizeof(rc_path), "%s/program.rc", project_dir);
    fp = fopen(rc_path, "w");
    if (!fp) return;
    fprintf(fp, "#include \"windows.h\"\n1 ICON \"program.ico\"\n");
    fclose(fp);
    const char *src_basename = g_path_get_basename(icon_path);
    char target_icon_path[512];
    snprintf(target_icon_path, sizeof(target_icon_path), "%s/%s", project_dir, src_basename);
    GFile *src = g_file_new_for_path(icon_path);
    GFile *dst = g_file_new_for_path(target_icon_path);
    g_file_copy(src, dst, G_FILE_COPY_OVERWRITE, NULL, NULL, NULL, NULL);
    g_object_unref(src);
    g_object_unref(dst);
    GtkWidget *dialog = gtk_message_dialog_new(NULL, GTK_DIALOG_DESTROY_WITH_PARENT,
        GTK_MESSAGE_INFO, GTK_BUTTONS_OK,
        "Project created:\n%s\n\nTo continue:\n- Open the icon file (%s) in GIMP\n"
        "- Export it as 32x32 .ico named 'program.ico'\n- Then compile with OpenWatcom.",
        project_dir, src_basename);
    gtk_dialog_run(GTK_DIALOG(dialog));
    gtk_widget_destroy(dialog);
}

void scan_desktop_files() {
    DIR *dir = opendir("/usr/share/applications/");
    struct dirent *entry;

    if (!dir) return;

    GHashTable *seen_names = g_hash_table_new(g_str_hash, g_str_equal);

    while ((entry = readdir(dir)) != NULL) {
        if (strstr(entry->d_name, ".desktop")) {
            char filepath[512], line[512], name[256] = "";
            snprintf(filepath, sizeof(filepath), "/usr/share/applications/%s", entry->d_name);
            FILE *fp = fopen(filepath, "r");
            if (!fp) continue;

            while (fgets(line, sizeof(line), fp)) {
                if (strncmp(line, "Name=", 5) == 0) {
                    sscanf(line + 5, "%255[^\n]", name);
                    break;
                }
            }
            fclose(fp);

            if (strlen(name) > 0 && !g_hash_table_contains(seen_names, name)) {
                AppEntry *app = g_malloc(sizeof(AppEntry));
                strncpy(app->name, name, sizeof(app->name));
                strncpy(app->filename, filepath, sizeof(app->filename));
                app->exec[0] = '\0';
                app_entries = g_list_append(app_entries, app);
                g_hash_table_add(seen_names, g_strdup(name));
            }
        }
    }

    g_hash_table_destroy(seen_names);
    closedir(dir);

    // Järjestetään lista nimen mukaan
    app_entries = g_list_sort(app_entries, (GCompareFunc)g_ascii_strcasecmp);

    // Lisätään rivit järjestyksessä listboxiin
    for (GList *l = app_entries; l != NULL; l = l->next) {
        AppEntry *app = (AppEntry *)l->data;
        GtkWidget *label = gtk_label_new(app->name);
        gtk_list_box_insert(GTK_LIST_BOX(listbox), label, -1);
    }

    gtk_widget_show_all(listbox);
}

int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);
    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "Whisker-style App List");
    gtk_window_set_default_size(GTK_WINDOW(window), 600, 500);
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
    GtkWidget *vbox = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
    gtk_container_add(GTK_CONTAINER(window), vbox);
    GtkWidget *scrolled = gtk_scrolled_window_new(NULL, NULL);
    gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC);
    gtk_box_pack_start(GTK_BOX(vbox), scrolled, TRUE, TRUE, 5);
    listbox = gtk_list_box_new();
    gtk_container_add(GTK_CONTAINER(scrolled), listbox);
    g_signal_connect(listbox, "row-selected", G_CALLBACK(on_row_selected), NULL);
    GtkWidget *hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10);
    gtk_box_pack_start(GTK_BOX(vbox), hbox, FALSE, FALSE, 5);
    test_button = gtk_button_new_with_label("Test Program");
    gtk_box_pack_start(GTK_BOX(hbox), test_button, FALSE, FALSE, 5);
    g_signal_connect(test_button, "clicked", G_CALLBACK(on_test_button_clicked), NULL);
    icon_preview = gtk_image_new();
    gtk_widget_set_size_request(icon_preview, 32, 32);
    gtk_box_pack_start(GTK_BOX(hbox), icon_preview, FALSE, FALSE, 5);
    make_button = gtk_button_new_with_label("Make EXE for XP");
    gtk_box_pack_start(GTK_BOX(hbox), make_button, FALSE, FALSE, 5);
    g_signal_connect(make_button, "clicked", G_CALLBACK(on_make_button_clicked), NULL);
    scan_desktop_files();
    gtk_widget_show_all(window);
    gtk_main();
    return 0;
}
