# pending.rb

Facter.add('windows_updates') do
  confine :kernel => 'windows'
  setcode do
    Facter::Core::Execution.exec('C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -noninteractive -noprofile -command "import-module C:\Windows\System32\WindowsPowerShell\v1.0\Modules\PSWindowsUpdate\Get-PendingUpdate.ps1; Get-PendingUpdate | select-object Title,MsrcSeverity"')
  end
end
