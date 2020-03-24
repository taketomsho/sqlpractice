# フォルダ内検索
Param($searchdir)
Get-ChildItem $searchdir -recurse `
    | Where-Object {$_.mode -like "-*"} `
    | Select-Object directory,name,length,LastAccessTime,LastWriteTime `
    | export-csv list.csv -notypeinformation
get-content analysis.sql | ./sqlite3.exe filelist.db
