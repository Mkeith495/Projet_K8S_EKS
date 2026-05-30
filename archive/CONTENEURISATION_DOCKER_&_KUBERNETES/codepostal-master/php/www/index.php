<?php
    include 'connect.php';

    function useragent_to_simple($ua) {
        // On simplifie le user agent pour ne garder que le navigateur et la version
        $ua = preg_replace('/\s+/', ' ', $ua);
        $ua = preg_replace('/\s*\(.*?\)\s*/', '', $ua);
        $ua = preg_replace('/\s*AppleWebKit.*?$/', '', $ua);
        $ua = preg_replace('/\s*Gecko.*?$/', '', $ua);
        return trim($ua);
    }

    // Si le formulaire a été soumis
    if (!empty($_GET['q'])) {
        $q = $_GET['q'];

        // Enregistrement de la requête dans l'historique
        $sql = "INSERT INTO historique (date, requete, ip, useragent) VALUES (NOW(), :requete, :ip, :useragent)";
        $prep = $lien->prepare($sql);
        $prep->bindValue(':requete', $q);
        $prep->bindValue(':ip', $_SERVER['REMOTE_ADDR']);
        $prep->bindValue(':useragent', $_SERVER['HTTP_USER_AGENT']);
        $prep->execute();
        
    } else {
        $q = '';
    }
?><!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Code postaux</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Code Postaux</h1>
        <h2>version_maxence</h2>

        <form action="" method="get">
            <div>
                <input type="search" name="q" placeholder="Entrer un code postal ou le nom d'une ville" value="<?= $q ?>" autocomplete="one-time-code">
                <div class="btns">
                    <input type="submit" value="Rechercher"> 
                    <input type="button" value="Historique" onclick="window.location.href='?h=1'">
                </div>
            </div>
        </form>

        <div class="resultats">
            <?php
                if (!empty($q)) {

                    // Si la requête ne contient que des chiffres, on recherche par code postal
                    if (ctype_digit($q)) {
                        $sql = "SELECT Code_postal AS cp_code, Nom_commune AS cp_ville 
                                FROM codepostal
                                WHERE Code_postal LIKE :cp
                                ORDER BY cp_code ASC";
                        $prep = $lien->prepare($sql);
                        $prep->bindValue(':cp', $q.'%');
                        $prep->execute();
                    } else {
                        // Sinon, on recherche par nom de ville
                        $sql = "SELECT Code_postal AS cp_code, Nom_commune AS cp_ville 
                                FROM codepostal
                                WHERE Nom_commune LIKE :ville
                                ORDER BY cp_code ASC";
                        $prep = $lien->prepare($sql);
                        $prep->bindValue(':ville', '%'.$q.'%');
                        $prep->execute();
                    }
                    
                    while ($cp = $prep->fetch(PDO::FETCH_ASSOC)) {
                        echo '<div class="ligne">';
                        echo '<span class="cp">'.$cp['cp_code']. '</span>';
                        echo '<span class="ville">'.$cp['cp_ville'].'</span>';
                        echo "</div>";
                    }
                }
            ?>
        </div>

        <div class="historique">
            <?php
                // Si l'historique est demandé
                if (!empty($_GET['h'])) {
                    echo '<h2>Historique des requêtes</h2>';
                    $sql = "SELECT date, requete, ip, useragent FROM historique ORDER BY date DESC";
                    $prep = $lien->prepare($sql);
                    $prep->execute();
                    
                    echo '<div class="historique">';
                    while ($h = $prep->fetch(PDO::FETCH_ASSOC)) {

                        $date = new DateTime($h['date']);
                        $h['date'] = $date->format('d/m/Y H:i:s');
                        $h['requete'] = htmlspecialchars($h['requete']);
                        $h['ip'] = htmlspecialchars($h['ip']);
                        
                        $browser = get_browser($h['useragent']);
                        $navigateur = $browser->browser;
                        $os = $browser->platform;

                        // On affiche l'historique
                        echo '<div class="ligne">';
                        echo '<div class="date">'.$h['date']. '</div>';
                        echo '<div class="requete"><span>Requête :</span> '.$h['requete'].'</div>';
                        echo '<div class="ip"><span>IP :</span> '.$h['ip'].'</div>';
                        echo '<div class="useragent"><span>User Agent : </span>'.$navigateur.' / ' . $os . '</div>';
                        echo "</div>";
                    }
                    echo '</div>';
                }
            ?>
        </div>
    </div>
</body>
</html>
