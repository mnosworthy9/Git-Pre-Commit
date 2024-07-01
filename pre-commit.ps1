class PreCommit {
  [System.Collections.Generic.List[String]]$stagedFiles;
  [Int]$spaceIndentation = 0;
  [Int]$lineNumber = 1;
  [Boolean]$hasError = $false;

  PreCommit() {
    Write-Host 'Starting Pre-Commit...';
    $this.GetCFilesFromDiff();
    $this.CheckForFormattingErrors();
  }

  [Void]GetCFilesFromDiff() {
    $this.stagedFiles = git diff --cached --name-only | Select-String -Pattern '\.c$'
  }

  [Void]CheckForFormattingErrors() {
    foreach($file in $this.stagedFiles) {
      foreach($line in $(git diff --cached --unified=0 -- $file | Select-String -Pattern '^\+.*'  | Where-Object { $_ -notmatch '^\+\+\+' })) {
        $line = $line.Line.Substring(1);
        if($this.OpenBraceIsOnSameLine($line)) {
          $this.FormatError("Place open brace on new line", $file);
        }
        $this.lineNumber++;
      }
      $this.lineNumber = 1;
    } 

    if($this.hasError) {
      exit 1;
    }
  }  

  [Boolean]OpenBraceIsOnSameLine([String]$line) {
    [Int]$openBracePosition = $line.IndexOf('{');
    if($openBracePosition -eq -1){
      return $false;
    }
    elseif($openBracePosition -gt $this.spaceIndentation) {
      $this.spaceIndentation +=2;
      return $true
    }
    $this.spaceIndentation +=2;
    return $false
  }

  [Void]FormatError([String]$message, [String]$file) {
    Write-Error "$($message): $($file):$($this.lineNumber)"
    $this.hasError = $true;
  }
}

[PreCommit]::new();