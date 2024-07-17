QueryToUrl(query, engine) {
    query := StrReplace(query, '&', '%26')
    query := StrReplace(query, '#', '%23')
    query := StrReplace(query, '+', '%2B')
    query := StrReplace(query, ' ', '+')
            ; URL encoding is used to encode special characters in query strings.
    return engine query
}

StrDelete(haystack, needle, limit := 1) {
    return StrReplace(haystack, needle, , , , limit)
}
