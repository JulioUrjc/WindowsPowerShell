# July powershell
_powershell functions, modules and scripts_

+ [Cloning](#Cloning)
+ [Modules and Manifest](#ModulesAndManifest)
+ [Author](#Author)
+ [Thank you](#Thankyou)

## <a name="Cloning"></a>Cloning 🛠️

>This repository contains modules,  scripts and Microsoft.PowerShell_profile:

```
C:\Users\youruser\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```
>Modules and Scripts same folder:

```
C:\Users\youruser\Documents\WindowsPowerShell\Modules
C:\Users\youruser\Documents\WindowsPowerShell\Scripts
```
>The Scripts have ps1 extension and you can add more.
>The Modules have psm1 extension and you have to create a folder with the same name.

## <a name="ModulesAndManifest">Modules and Manifest 📢

>Modules require export functions and alias, example:
```
Export-ModuleMember -function lsGetColorAndSize, lsGetColorAndSizeRecursive, coloresPosibles -Alias lsa,lsr
```

>You can create module manifest, the help file [CrearManifest.txt](Modules/CrearManifest.txt) can help you do this, fill in the file with your own data and run:

```
$path = "$env:userprofile\documents\WindowsPowerShell\Modules\modulename\modulename.psd1"

$guid = [guid]::NewGuid().guid
```

```
$paramHash = @{
 Path = $path
 RootModule = "moduleName.psm1"
 Author = "YourName"
 CompanyName = ""
 ModuleVersion = "1.0"
 Guid = $guid
 PowerShellVersion = "5.0"
 Description = "description module"
 FormatsToProcess = ""
 FunctionsToExport = "*"
 AliasesToExport = "*"
 VariablesToExport = ""
 CmdletsToExport = ""
}
```
>And finally:
```
New-ModuleManifest @paramHash
```

### <a name="Author">Author ✒️

* **Julio Martin** - *Initial work and documentation* - [JulioMartin](https://github.com/JulioUrjc)

<!-- También puedes mirar la lista de todos los [contribuyentes](https://github.com/your/project/contributors) quíenes han participado en este proyecto.--> 

### <a name="Thankyou">Thank you 🎁

 <!-- 📢 🍺 🤓 📄 📌 🖇️ 🔧 ⌨️ 🔩 ⚙️ 🚀 📋-->

- Manifest from https://www.petri.com/how-to-create-a-powershell-module
