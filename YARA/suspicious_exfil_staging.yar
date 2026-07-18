rule Suspicious_Exfil_Staging
{
    meta:
        description = "Detects SOC lab fake sensitive staging files"
        author = "SOC Analyst Lab"
        date = "2026-07-18"
        reference = "T1074 Collection - Data Staged"
        severity = "medium"
        lab_only = "true"

    strings:
        $a1 = "SOC-LAB-SENSITIVE-MARKER" ascii wide
        $a2 = "SOC-LAB-DATA" ascii wide
        $a3 = "customer_export_fake" ascii wide
        $a4 = "ssn_fake=" ascii
        $a5 = "credit_card_fake=" ascii

    condition:
        2 of them
}
