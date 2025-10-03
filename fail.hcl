mock "tfplan/v2" {
    module {
        source = "../../tfplan-fail.json"  # plan already has public SSH
    }
}

test {
    rules = {
        main = false
    }
}
