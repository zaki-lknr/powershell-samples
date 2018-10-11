# 認証情報の取得と保存
# スケジュールジョブ(PowerShell)でパスワードをセキュアに使う(セキュアストリング編)
# http://www.vwnet.jp/windows/WS08R2/PSPassword/SecurePassword.htm

$password_file = "password.xml"

# 認証
if (Test-Path $password_file) {
    # ファイルがあれば読み込み
    $cred = Import-Clixml $password_file
    $secure_pass = $cred.pass | ConvertTo-SecureString
}
else {
    # ファイルがなければ認証プロンプトを起動
    $credential = Get-Credential
    # XML形式で保存
    $cred = @{}
    $cred.Add("pass", ($credential.Password | ConvertFrom-SecureString))
    $cred.Add("user", $credential.UserName)
    $cred | Export-Clixml $password_file
    $secure_pass = $cred.pass | ConvertTo-SecureString
}

$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure_pass)
$cred.pass = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)

echo $cred.user
echo $cred.pass