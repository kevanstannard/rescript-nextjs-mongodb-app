type checkResult = {score: int}

@bs.module
external check: string => checkResult = "zxcvbn"
