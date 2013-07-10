function SaveGame(jsondata) {
	console.log("save start");
	var userid = document.getElementById("userid");
	if (userid == null) {
		console.log("userid is not found");
	} else {
		console.log("userid=" + userid.value);
		jsondata = jsondata.replace("%d", userid.value);
	    var xhr = new XMLHttpRequest();
	    xhr.open("POST", "http://192.168.100.29/save.php");
	    xhr.setRequestHeader("Content-Type", "application/json");
	    xhr.onreadystatechange = function () {
	        if (xhr.readyState == 4 && xhr.status == 200) {
	            // save success
	            console.log("Save success");
	        }
	    }
	    xhr.send(jsondata);
    }
}

function LoadGame(jsondata) {
	return "Test";
}

