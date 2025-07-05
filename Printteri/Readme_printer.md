# 🖨️ Printing Setup on Windows XP – MX·Link·XP v1.04

## 1. Add a Printer
1. Open: **Control Panel → Printers and Faxes → Add Printer**
2. Select: **Local printer attached to this computer**
3. Use existing port: **LPT1:** → click **Next**
4. Manufacturer: **HP**
5. Printer: **HP Color LaserJet PS**
6. Click **Next**, then **Finish**

---

## 2. Install RedMon
1. Go to folder: `<drive letter>:\MXP\Printteri\redmon`
2. Run: `setup.exe`

> 🧩 RedMon adds a virtual printer port that redirects print jobs to an external print management program — in this case, `Tulosta.exe`.

---

## 3. Configure the RedMon Port
1. Open: **Printers and Faxes**
2. Right-click **HP Color LaserJet PS** → **Properties**
3. Go to the **Ports** tab
4. Click: **Add Port…**
   - Select: **Redirected Port Monitor**
   - Click **Add Port…**
   - Enter name: `RPT1:` → click **OK**
5. Select the new **RPT1:** port
6. Click: **Configure Port…**

### Fill in the following:
- **Redirect this port to the program:**  
  `<drive letter>:\MXP\Printteri\Tulosta.exe`
- **Arguments for this program:**  
  *(leave empty)*
- **Output:**  
  `Program handles output`
- ✅ **Run as user:**  
  *(check this box)*
- ⬜ **Use alternate user credentials:**  
  *(leave unchecked)*

7. Click **OK**, then close the printer properties window.

---

## 4. Test the Printer
1. Open **Notepad**
2. Write a short message
3. Choose **Print** → Select **HP Color LaserJet PS**
4. The job is passed to `Tulosta.exe`, which creates a file in the RAM-disk
5. On the Linux side, `ajavahti` daemon detects the file and sends it to the default printer
