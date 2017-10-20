function authenticateUser(username, password){
	var accounts = [["joao","123"],["maria","456"]];

	for(var i=0; i < accounts.length; i++){
		var account = accounts[i];
		if(account[0] === username && account[1] === password){
			return true;
		}
	}

	return false
}
