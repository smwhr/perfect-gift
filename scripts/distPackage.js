'use strict';

const fs = require('fs');

let packageFile = fs.readFileSync(__dirname + "/../package.json");

const DIST_KEYS = [ "name",
					"author",
					"description",
					"license",
					"version",
					"main"]

let full = JSON.parse(packageFile);
let cleaned = Object.fromEntries(
					Object.entries(full)
						  .filter( ([key, config]) => {
						  	return DIST_KEYS.includes(key)
						  })
						  .map(([key, config]) => {
						  	if(key == "main"){
						  		return [key, config.replace("dist/", "")]
						  	}else{
						  		return [key, config]
						  	}
						  })
			  );
fs.writeFileSync(__dirname + "/../dist/package.json", JSON.stringify(cleaned));



