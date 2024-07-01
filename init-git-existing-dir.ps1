class InitGit {
  [System.Collections.Generic.List[String]] $private:directoriesContainingGit;  

  InitGit([String]$basePath) {
    if($null -eq $basePath) {
      $basePath = 'C:';
    }

    $this.directoriesContainingGit = Get-ChildItem -Path $basePath -Recurse -Force -Directory -ErrorAction SilentlyContinue 
    | Where-Object { $_.Name -eq '.git' } 
    | Select-Object -ExpandProperty FullName 
    | ForEach-Object { $_ -replace '\\\.git$', '' } 

    foreach($dir in $this.directoriesContainingGit) {
      Remove-Item "$basePath\.git\hooks\pre-commit.ps1" -ErrorAction SilentlyContinue;
      Remove-Item "$basePath\.git\hooks\pre-commit" -ErrorAction SilentlyContinue;
      Write-Host "initialising git in: $dir"
      git init --template="$(git config --global --get init.templateDir)" "$dir"
    }
  }
}