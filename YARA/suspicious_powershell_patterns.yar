rule Suspicious_PowerShell_Encoded_Snippet
{
    meta:
        description = "Flags scripts referencing encoded PowerShell launch patterns"
        author = "SOC Analyst Lab"
        date = "2026-07-18"
        severity = "high"

    strings:
        $p1 = "EncodedCommand" ascii wide nocase
        $p2 = " -enc " ascii wide nocase
        $p3 = "FromBase64String" ascii wide
        $p4 = "DownloadString" ascii wide nocase
        $p5 = "IEX(" ascii wide nocase
        $p6 = "Invoke-Expression" ascii wide nocase

    condition:
        2 of them
}
