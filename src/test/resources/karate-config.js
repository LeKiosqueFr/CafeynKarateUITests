function fn() {
    var env = karate.env; // get system property

    if (!env) {
		//Default env.
        env = 'preprod';
    }

    var config = {
        apiBaseURL: 'https://api.cafeyn.co',
        uiBaseURL: 'https://staging.cafeyn.co',
        env: env,
        headersConfig: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'AccessKeyId': 'iosp04',
            'udid': '419F5414-4570-4E4F-8DBD-385A57BFE081',
            'productId': 'cafeyn'
        }
    };

    if (env === 'preprod') {
        config.apiBaseURL = 'https://preprod-api.cafeyn.co';
        config.uiBaseURL = 'https://preprod.cafeyn.co';
        karate.configure('connectTimeout', 60000);
    } else if (env === 'prod') {
        config.apiBaseURL = 'https://api.cafeyn.co';
        config.uiBaseURL = 'https://cafeyn.co';
        karate.configure('connectTimeout', 30000);
    } else if (env === 'staging') {
        config.apiBaseURL = 'https://staging-api.cafeyn.co';
        config.uiBaseURL = 'https://staging.cafeyn.co';
        karate.configure('connectTimeout', 30000);
    } else if (env === 'dev') {
        config.apiBaseURL = 'https://dev-api.cafeyn.co';
        config.uiBaseURL = 'https://dev.cafeyn.co';
        karate.configure('connectTimeout', 30000);
    }

    return config;
}