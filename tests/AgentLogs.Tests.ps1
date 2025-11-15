using namespace 'System.IO'

BeforeAll {
    $scriptRoot = (Get-Item -Path $PSScriptRoot).Parent.FullName
    . "$scriptRoot/AgentLogs.ps1"
    
    # Create test directories
    $testDirs = @('incidents', 'daily', 'changes', 'notes', 'successful')
    foreach ($dir in $testDirs) {
        $path = Join-Path -Path $scriptRoot -ChildPath $dir
        if (-not (Test-Path -Path $path)) {
            New-Item -ItemType Directory -Path $path | Out-Null
        }
    }
}

Describe 'AgentLogs.ps1' {
    Context 'Get-DateParts' {
        It 'should return a PSCustomObject with the correct properties' {
            $dateParts = Get-DateParts
            $dateParts | Should -BeOfType ([pscustomobject])
            $dateParts.PSObject.Properties.Name | Should -BeIn (('Date', 'Ts', 'Iso'))
        }
    }

    Context 'Initialize-LogDirs' {
        It 'should create the log directories' {
            Initialize-LogDirs
            foreach ($d in $Dirs) {
                (Test-Path $d) | Should -Be $true
            }
        }
    }
    
    Context 'Find-OldLogs' {
        It 'should find logs older than 30 days' {
            # Create a dummy old file
            $oldFilePath = Join-Path -Path 'notes' -ChildPath 'old_log.md'
            New-Item -Path $oldFilePath -ItemType File -Force | Out-Null
            (Get-Item $oldFilePath).LastWriteTime = (Get-Date).AddDays(-31)
            
            $oldLogs = Find-OldLogs
            $oldLogs.Name | Should -Contain 'old_log.md'
            
            # Clean up the dummy file
            Remove-Item -Path $oldFilePath -Force
        }
    }
}
