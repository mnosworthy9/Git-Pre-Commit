. $PSScriptRoot\setup-hooks.ps1;
. $PSScriptRoot\init-git-existing-dir.ps1;

<#
.SYNOPSIS
# Adds Pre-Commit files to the hooks folder in directories containing .git

.DESCRIPTION
Can be used to create a `.git_templates` directory in the home path, 
it will then add 2 pre-commit files in there overwriting any existing.

It can also update every folder with git already initialised,
deleting old Pre-Commit files and then adding the new ones.

.PARAMETER hard
Goes through every directory when this param is present.

.PARAMETER basePath
When the -Hard param is used this will specify the base directory to search for .git folders.

.EXAMPLE
Add-GitPreCommit -Hard -BasePath "C:Dev"

.NOTES
Can also run git init in a directory after deleting pre-commit files to add the template directory to a repo.
#>
function Add-GitPreCommit([Switch]$hard, [String]$basePath){
  [SetupHooks]::new();

  if($true -eq $hard) {
    [InitGit]::new($basePath);
  }

}