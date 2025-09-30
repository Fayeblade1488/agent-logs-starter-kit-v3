# PSScriptAnalyzer Ruleset

@{
    # Specify rules to include. By default, all rules are included.
    IncludeRules = @(
        'PSAvoidUsingCmdletAliases',
        'PSAvoidUsingWriteHost',
        'PSUseApprovedVerbs',
        'PSAvoidUsingPositionalParameters'
    )

    # Specify rules to exclude
    # ExcludeRules = @('PSSomeRuleToExclude')

    # Specify severity of rules
    Severity = @(
        'Error',
        'Warning'
    )
}
