# Import-Module ActiveDirectory nécessaire
Import-Module ActiveDirectory

# Définir le chemin du fichier CSV
$CSVPath = "C:\Chemin\Vers\TonFichier.csv"

function Ajouter-Utilisateurs {
    $utilisateurs = Import-Csv -Path $CSVPath | Where-Object { $_.Action -eq "Ajouter" }
    foreach ($u in $utilisateurs) {
        try {
            if (Get-ADUser -Filter { SamAccountName -eq $u.SamAccountName } -ErrorAction Stop) {
                Write-Host "L'utilisateur $($u.SamAccountName) existe déjà." -ForegroundColor Yellow
            }
        } catch {
            New-ADUser -Name "$($u.Prenom) $($u.Nom)" `
                        -GivenName $u.Prenom `
                        -Surname $u.Nom `
                        -SamAccountName $u.SamAccountName `
                        -AccountPassword (ConvertTo-SecureString $u.MotDePasse -AsPlainText -Force) `
                        -Enabled $true `
                        -Path "OU=Utilisateurs,DC=B1,DC=com" # À adapter selon ton domaine
            Add-ADGroupMember -Identity $u.Groupe -Members $u.SamAccountName
            Write-Host "Utilisateur $($u.SamAccountName) ajouté avec succès." -ForegroundColor Green
        }
    }
}

function Lister-Utilisateur {
    $SamAccountName = Read-Host "Entrez le SamAccountName de l'utilisateur à rechercher"
    try {
        $utilisateur = Get-ADUser -Identity $SamAccountName -Properties *
        Write-Host "Utilisateur trouvé : $($utilisateur.Name) - Groupe(s): $($utilisateur.MemberOf)" -ForegroundColor Cyan
    } catch {
        Write-Host "Utilisateur $SamAccountName introuvable." -ForegroundColor Red
    }
}

function Modifier-Utilisateurs {
    $utilisateurs = Import-Csv -Path $CSVPath | Where-Object { $_.Action -eq "Modifier" }
    foreach ($u in $utilisateurs) {
        try {
            $ancienUser = Get-ADUser -Identity $u.AncienSamAccountName
            if ($ancienUser) {
                Rename-ADObject -Identity $ancienUser.DistinguishedName -NewName "$($u.Prenom) $($u.Nom)"
                Set-ADUser -Identity $ancienUser -SamAccountName $u.SamAccountName `
                           -GivenName $u.Prenom `
                           -Surname $u.Nom
                Write-Host "Utilisateur $($u.AncienSamAccountName) modifié en $($u.SamAccountName)." -ForegroundColor Green
            }
        } catch {
            Write-Host "Erreur lors de la modification de $($u.AncienSamAccountName)." -ForegroundColor Red
        }
    }
}

function Supprimer-Utilisateurs {
    $utilisateurs = Import-Csv -Path $CSVPath | Where-Object { $_.Action -eq "Supprimer" }
    foreach ($u in $utilisateurs) {
        try {
            Remove-ADUser -Identity $u.SamAccountName -Confirm:$false
            Write-Host "Utilisateur $($u.SamAccountName) supprimé." -ForegroundColor Green
        } catch {
            Write-Host "Erreur lors de la suppression de $($u.SamAccountName)." -ForegroundColor Red
        }
    }
}

function Toutes-Les-Actions {
    Ajouter-Utilisateurs
    Modifier-Utilisateurs
    Supprimer-Utilisateurs
}

# --- MENU ---
do {
    Clear-Host
    Write-Host "======== MENU GESTION UTILISATEURS AD ========" -ForegroundColor Cyan
    Write-Host "1 - Ajouter tous les utilisateurs"
    Write-Host "2 - Lister un utilisateur spécifique"
    Write-Host "3 - Modifier tous les utilisateurs"
    Write-Host "4 - Supprimer tous les utilisateurs"
    Write-Host "5 - Toutes les actions en même temps"
    Write-Host "6 - Quitter"
    Write-Host "============================================="

    $choix = Read-Host "Votre choix (1-6)"

    switch ($choix) {
        "1" { Ajouter-Utilisateurs }
        "2" { Lister-Utilisateur }
        "3" { Modifier-Utilisateurs }
        "4" { Supprimer-Utilisateurs }
        "5" { Toutes-Les-Actions }
        "6" { Write-Host "Sortie du programme." -ForegroundColor Yellow }
        default { Write-Host "Choix invalide. Veuillez entrer un numéro entre 1 et 6." -ForegroundColor Red }
    }

    if ($choix -ne "6") {
        Pause
    }
} while ($choix -ne "6")