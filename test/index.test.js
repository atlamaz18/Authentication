let axios;

function user_login_test_valid() {
    axios
        .post("http://127.0.0.1:8000//users/login", {
            "email" : " burak@test.com ",
            "password" : "ab12"
        })
        .then((res) => {
            if(res.status=="200"){
                console.log("user_login_test_valid() TRUE")
        }
    });
}

function user_wrong_login_test_invalid_email() {
    axios
        .post("http://127.0.0.1:8000//users/login", {
            "email": " burk@test.com ",
            "password": "ab12"
        })
        .then((res) => {
            if (res.status == "200")
                console.log("user_wrong_login_test_invalid_email() FALSE")
            console.log()
        })
        .catch(error => {
            console.log("user_wrong_login_test_invalid_email() TRUE")
        });
}

function user_defined_location_true_test() {
    axios
        .post("http://127.0.0.1:8000//users/login", {
            "latitude": " 41.10890 ",
            "longitude": "29.03520"
            "date" : "24-05-2023 - 20:25:03"
            "email" : "burak@test.com"
        })
        .then((res) => {
            if (res.status == "200")
                console.log("user_defined_location_true_test TRUE")
            console.log()
        });
}

function user_defined_location_false_test() {
    axios
        .post("http://127.0.0.1:8000//users/login", {
            "latitude": " 41.10890 ",
            "longitude": "29.03520"
            "date" : "24-05-2023 - 20:25:03"
            "email" : "burak@test.com"
        })
        .then((res) => {
            if (res.status == "200")
                console.log("user_defined_location_false_test() FALSE")
            console.log()
        })
        .catch(error => {
            console.log("user_defined_location_false_test() TRUE")
        });
}

function last_location_true_test() {
    axios
        .post("http://127.0.0.1:8000//users/login", {
            "latitude": " 41.10890 ",
            "longitude": "29.03520"
            "date" : "24-05-2023 - 20:25:03"
            "email" : "anıl@test.com"
        })
        .then((res) => {
            if (res.status == "200")
                console.log("user_defined_location_true_test TRUE")
            console.log()
        });
}

function last_location_false_test() {
    axios
        .post("http://127.0.0.1:8000//users/login", {
            "latitude": " 41.06320 ",
            "longitude": "28.99717"
            "date" : "24-05-2023 - 20:25:03"
            "email" : "anıl@test.com"
        })
        .then((res) => {
            if (res.status == "200")
                console.log("last_location_false_test() FALSE")
            console.log()
        })
        .catch(error => {
            console.log("last_location_false_test() TRUE")
        });
}

user_login_test_valid()
user_wrong_login_test_invalid_email()
user_defined_location_true_test()
user_defined_location_false_test()
last_location_true_test()
last_location_false_test()