<html>
<body>
	<p><a href="/">Main Menu</a></p>
	<?php
        // Esto asegura que se muestren los errores de PHP en el navegador
        ini_set('display_errors', 1);
        error_reporting(E_ALL);
	?>
    <br/>
    <h1>Variables de Servidor y Shibboleth</h1>
    <?php
        phpinfo(INFO_VARIABLES);
    ?>
</body>
</html>