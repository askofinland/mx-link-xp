# Antijumi (AntiHang)

Antijumi (AntiHang) is a lightweight C program that monitors system performance by measuring delay in a standardized loop. If the delay exceeds a user-defined threshold, the program automatically terminates predefined heavy applications such as web browsers, Thunderbird, and wineserver.

## Purpose

Antijumi is designed especially for environments where the system may run for several weeks without a reboot. In such cases, applications like browsers may gradually consume increasing amounts of system resources, causing slowdowns and degraded usability. Antijumi aims to prevent situations where rebooting the machine would be the only remaining solution.

## Operating Principle

The program measures the duration of a loop with second-level precision. By default, the loop includes a 10-second delay (`sleep`). If the measured delay exceeds the allowed threshold (defined by the user, in milliseconds), the program performs the following actions:

- Terminates the following processes using the `pkill -9` command:
  - `chrome`
  - `chromium`
  - `firefox`
  - `opera`
  - `thunderbird`
- Executes `wineserver -k` to shut down background Wine processes (if available)

The program operates fully automatically. When the specified delay threshold is exceeded, Antijumi executes its actions immediately without user confirmation. This enables effective intervention in situations where the system is heavily loaded and user input may no longer be responsive.

## Compilation and Installation

Compile the source code and move the binary to the system's executable path:

```bash
gcc antijumi.c -o antijumi
sudo mv antijumi /usr/bin/
```

You can then run the program from anywhere:

```bash
antijumi 30
```

The example above starts Antijumi in the background and allows a maximum delay of 30 milliseconds.

## Integration with MX*link*XP

The MX*link*XP setup creates a startup script at `/usr/bin/xp`, which is used to launch the XP virtual environment and related processes. Antijumi can be integrated directly into this script by adding the following line:

```bash
antijumi 30 &
```

Insert the line into `/usr/bin/xp`, preferably just before launching the XP environment. This ensures that Antijumi begins monitoring automatically whenever MX*link*XP is started.

## Limitations

- The program does not provide graphical warnings before terminating processes.
- Only hardcoded processes are terminated. Other resource-consuming applications remain unaffected.
- Requires an environment where `pkill` is available.

## License

This program is released as open source. You are free to use, modify, and distribute it.

🇬🇧 Support
If Antijumi has been useful to you, you can support its development:

PayPal: askofinland@live.com
