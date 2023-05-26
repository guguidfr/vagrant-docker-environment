# Comprobar si el usuario tiene privilegios de administrador
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "Este script requiere privilegios de administrador. Ejecute PowerShell como administrador e intente nuevamente."
    Exit 1
}

# Comprobar si la característica opcional de Windows OpenSSH Client está instalada y desinstalarla si es así
$openSshFeature = Get-WindowsOptionalFeature -Online -FeatureName "OpenSSH.Client"
if ($null -ne $openSshFeature ) {
    Write-Host "Desinstalando la característica opcional de Windows OpenSSH Client..."
    Disable-WindowsOptionalFeature -Online -FeatureName "OpenSSH.Client" -NoRestart
}

# Instalar Chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Set-ExecutionPolicy Restricted -Scope Process -Force
}

# Instalar VirtualBox
Write-Host "Instalando VirtualBox..."
choco install virtualbox -y

# Instalar Vagrant
Write-Host "Instalando Vagrant..."
choco install vagrant -y

# Instalar Visual Studio Code (VSCode)
Write-Host "Instalando Visual Studio Code (VSCode)..."
choco install vscode -y

# Instalar Git
Write-Host "Instalando Git..."
choco install git -y

# Lista de extensiones de VSCode a instalar
$extensions = @(
    "bbenoist.vagrant",
    "marcostazi.VS-code-vagrantfile",
    "ms-python.python",
    "oderwat.indent-rainbow"
)

# Instalar extensiones de VSCode
Write-Host "Instalando extensiones de VSCode..."
foreach ($extension in $extensions) {
    Write-Host "Instalando extensión $extension..."
    code --install-extension $extension
}

Write-Host "¡La instalación de Chocolatey, VirtualBox, Vagrant, VSCode y las extensiones de VSCode se ha completado exitosamente!"