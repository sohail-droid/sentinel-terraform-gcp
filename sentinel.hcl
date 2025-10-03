import "static" "tfplan/v2" {
    source = "./policy/tfplan-pass.json"
    format = "json"
}


policy "validate-gcp-security" {
    source = "./policy/validate-gcp-security.sentinel"
    enforcement_level = "advisory"
}

