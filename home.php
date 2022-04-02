<?php
// Initialize the session
session_start();
require_once 'connect.php';

// Check if the user is logged in, if not then redirect him to login page
if(!isset($_SESSION["loggedin"]) || $_SESSION["loggedin"] !== true){
    header("location: login.php");
    exit;
}
$search = '';
if(isset($_POST['search'])){
    $search = $_POST['search'];
}
function deleteUser($username, $conn){
        $query = 'CALL deleteuser(?)';
        if($stmt = mysqli_prepare($conn, $query)){
            mysqli_stmt_bind_param($stmt, "s", $param_username);
            
            $param_username = $username;
            if(mysqli_stmt_execute($stmt)){
                echo 'Success';
                echo "Record with username: ".$username." deleted successfully";
                exit();
            } else{
                echo "Oops! Something went wrong. Please try again later.";
            }
            mysqli_stmt_close($stmt);
        }
        mysqli_close($conn);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body{ font: 14px sans-serif; text-align: center; }
    </style>
</head>
<body>
    <h1 class="my-5">Welcome, <b><?php echo htmlspecialchars($_SESSION["username"]); ?></b>!</h1>
    <p><?php echo $_SESSION['bio'] ?></p>
    <p class="d-flex justify-content-center">
        <a href="update.php" class="btn btn-primary ml-3">Edit</a>
        <a href="logout.php" class="btn btn-danger ml-3">Sign Out of Your Account</a>
    </p>
    <br><br>
    <div class="container">
        <div class="card">
            <div class="header">
                <form action="home.php" method="post">
                    <div class="row mt-3">
                        <div class="col-md-4 ml-4">
                            <input class="form-control" type="text" name="search" id="search" value="<?php echo  $search; ?>" placeholder="Search by username...">
                        </div>
                        <div class="col-md-1">
                            <button type="submit" class="btn btn-secondary" name="btnSearch" onclick="<?php isset($_POST['search']) ? $search=$_POST['search'] : $search = ''; ?>">Search</button>
                        </div>
                        <?php
                        if ($_SESSION['username']=='admin' and isset($_POST['search']) and $_POST['search']!='') {                        
                            echo '<div class="col-md-1">
                                <button class="btn btn-danger" name="btnDelete">delete</button>
                            </div>';
                            if(isset($_POST['btnDelete'])){
                                deleteUser($search, $db);
                            }
                        }
                        ?>
                    </div>
                </form>
            </div>
            <div class="card-body">
                <table class="table">
                    <?php 
                        if(isset($_POST['btnSearch']) and $_POST['search'] != ''){
                            $query = 'SELECT username, bio FROM usuarios WHERE username = "'.$_POST['search'].'";';
                            $users = mysqli_query($db, $query);
                        }else {
                            $search = '';
                            echo "Search a username! Remember only admin can delete users";
                            $users = mysqli_query($db,'SELECT id, username, bio FROM usuarios');
                        }
                    ?>
                </table>
            </div>
        </div>
    </div>
    <div id="content">
        <?php
            $query = "CALL registros();";
            $dataSet = mysqli_query($db, $query);
        ?>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th scope="col">Username</th>
                        <th scope="col">Name</th>
                    </tr>
                </thead>
            <tbody>    
        <?php
            while($row = mysqli_fetch_assoc($dataSet)){
                echo "<tr>";
                    echo "<td>".$row['username']."</td>";
                    echo "<td>".$row['name']."</td>";
                echo "</tr>";
            }
        ?>
            </tbody>
            </table>
    </div>
</body>
</html>