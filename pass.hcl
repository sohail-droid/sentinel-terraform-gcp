mock "tfplan/v2" {
    module {
        source = "../../tfplan-pass.json"       #plan dont have public ssh
    }
}


test {
    rules = {
        main = true
    }
}
