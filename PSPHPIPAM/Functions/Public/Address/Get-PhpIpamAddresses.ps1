function Get-PhpIpamAddresses{
    [cmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(
            Mandatory=$false,
            ParameterSetName="ByCIDR"
        )]
        [string]
        $CIDR,
        [Parameter(
            Mandatory=$false,
            ParameterSetName="All"
        )]
        [Boolean]
        $All=$true
    )

    begin{

    }
    process{
            if ($PsCmdlet.ParameterSetName -eq "ByCIDR"){
                get-PhpIpamSubnetByCIDR -CIDR $CIDR|foreach-object{
                    Get-PhpIpamSubnetAddressesByID -ID $_.id
                }
            }

            if($ALL){
                Get-PhpIpamSubnets|ForEach-Object{
                    Get-PhpIpamSubnetAddressesByID -id $_.id
                }
            }
    }

    end{

    }
}

Export-ModuleMember -Function Get-PhpIpamAddresses
