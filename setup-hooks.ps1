class SetupHooks {
  [string]$hooksDirectory;
  [string]$private:preCommitScript = '.\pre-commit.ps1';
  [String]$private:preCommitScriptExecutor = '.\pre-commit'

  SetupHooks() {
    $this.hooksDirectory = "$env:HOMEDRIVE$env:HOMEPATH\.git_template\hooks";
    
    Write-Host "Adding template directory to: $($this.hooksDirectory)";
    New-Item $this.hooksDirectory -ItemType Directory -Force

    Copy-Item -Path $this.preCommitScript -Destination $this.hooksDirectory -Force
    Copy-Item -Path $this.preCommitScriptExecutor -Destination $this.hooksDirectory -Force

    git config --global init.templateDir "$env:HOMEDRIVE$env:HOMEPATH\.git_template"
  }
}