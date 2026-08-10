//
// Copyright (C) 2026 Curity AB. All rights reserved.
//
// The contents of this file are the property of Curity AB.
// You may not copy or use this file, in either source code
// or executable form, except in compliance with terms
// set by Curity AB.
//
// For further information, please contact Curity AB.
//

import Foundation

#if DEBUG

@available(iOS 14.0, *)
internal enum HaapiPreviewDefaults {}

// MARK: - Form (Login)

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {

    static let formJSON: String = """
    {
      "links": [
        {
          "href": "/dev/authn/authenticate/htmlSql/forgot-password",
          "rel": "forgot-password",
          "title": "Forgot your password?"
        },
        {
          "href": "/dev/authn/authenticate/htmlSql/forgot-account-id",
          "rel": "forgot-account-id",
          "title": "Forgot your username?"
        },
        {
          "href": "/dev/authn/register/create/htmlSql",
          "rel": "register-create",
          "title": "Create account"
        }
      ],
      "metadata": {
        "templateArea": "html1",
        "viewName": "authenticator/html-form/authenticate/get"
      },
      "type": "authentication-step",
      "actions": [
        {
          "template": "form",
          "kind": "login",
          "title": "Login",
          "model": {
            "href": "/dev/authn/authenticate/htmlSql",
            "method": "POST",
            "type": "application/x-www-form-urlencoded",
            "title": "Login",
            "actionTitle": "Login",
            "fields": [
              {
                "name": "userName",
                "type": "username",
                "label": "Username"
              },
              {
                "name": "password",
                "type": "password",
                "label": "Password"
              }
            ]
          }
        }
      ]
    }
    """
}

// MARK: - Selector (Authenticator Selection)

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {

    static let selectorJSON: String = """
    {
      "metadata": {
        "viewName": "views/select-authenticator/index"
      },
      "type": "authentication-step",
      "actions": [
        {
          "template": "selector",
          "kind": "authenticator-selector",
          "title": "Select Authentication Method",
          "model": {
            "options": [
              {
                "template": "form",
                "kind": "select-authenticator",
                "title": "google1",
                "properties": {
                  "authenticatorType": "google"
                },
                "model": {
                  "href": "/dev/authn/authenticate/google1",
                  "method": "GET"
                }
              },
              {
                "template": "form",
                "kind": "select-authenticator",
                "title": "username",
                "properties": {
                  "authenticatorType": "username"
                },
                "model": {
                  "href": "/dev/authn/authenticate/username",
                  "method": "GET"
                }
              }
            ]
          }
        }
      ]
    }
    """
}

// MARK: - Polling

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {

    static let pollingJSON: String = """
        {
            "messages":
            [
                {
                    "text": "Please authenticate using the SMS sent to: xxxxxx7890",
                    "classList":
                    []
                }
            ],
            "links":
            [
                {
                    "href": "/dev/authn/anonymous/sms1",
                    "rel": "register-create",
                    "title": "Register or change phone number"
                }
            ],
            "metadata":
            {
                "viewName": "authenticator/sms/link-wait/get"
            },
            "type": "polling-step",
            "properties":
            {
                "recipientOfCommunication": "xxxxxx7890",
                "status": "pending"
            },
            "actions":
            [
                {
                    "template": "form",
                    "kind": "poll",
                    "model":
                    {
                        "href": "/dev/authn/authenticate/sms1/link-wait",
                        "method": "POST"
                    }
                },
                {
                    "template": "form",
                    "kind": "cancel",
                    "title": "Restart the process",
                    "model":
                    {
                        "href": "/dev/authn/authenticate/sms1",
                        "method": "GET",
                        "actionTitle": "Restart the process"
                    }
                }
            ]
        }
    """
}

// MARK: - Problem (Invalid Input)

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {

    static let problemJSON: String = """
    {
        "messages":
        [
            {
                "text": "You are not authorized to execute this request.",
                "classList":
                [
                    "error"
                ]
            },
            {
                "text": "A session can only be accessed using the original DPoP keys.",
                "classList":
                [
                    "error"
                ]
            }
        ],
        "links":
        [
            {
                "href": "/dev/authn/authenticate",
                "rel": "restart",
                "title": "Try again"
            }
        ],
        "code": "authorization_failed",
        "type": "https://curity.se/problems/unexpected",
        "title": "General Error"
    }
    """
}

// MARK: - BankId

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {

    // swiftlint:disable line_length
    static let bankIdJSON: String = """
    {
        "messages":
        [
            {
                "text": "Trying to start your BankID app",
                "classList":
                [
                    "info"
                ]
            }
        ],
        "links":
        [
            {
                "href": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAPoAAAD6AQAAAACgl2eQAAACkklEQVR4Xu2YMY7rMAxEGaRQ6SPoJsnFDChALhbfxEdwqcIw/8zwOz/JAtua+IgKr619hcmQw5HNf18P+9z5WF8g1heIlQVYDavNZVqa94tZLb5Y5WZNBODvMtZ+8lstDxurXXAp8Y88gJ2WNuNy5sZYfQIvNBnAB787393sMrhnBJrbFVWADYQy4S4dwHqwsqFyUbSj9Sv2fhTMwQCbCAWgKnhePlvvYCDWrFLtNjDzCkArC4AoTgtfeuAdULQ/kz7cEwHcGXChmkpIfQq1eqY6AYDcoqmsgyCuUFTIbQ8zAYAAmGB/MBQKPTrrPhc8JgLQ6hsC0LREln3XAIp/HsAQAF57ktpTQ3XHosgEhDIhlMoEs6nWivJozyiOB3wu2yDq7KDGmPWIgisLsLLV2+wb800e9XCmq3spmMMBNdUNXk5qT2XCcI/0ZwI41+mQZJPcqVEo5JcojgdWQje+O6y7YVvWDhNqH0lJAGqUs+ntuj++a9ThANaGegghRYIp9G8alQKYO70cHJJrzCuU6qyRPMBKG3yf5YVVD6xcatQeRQZAXhPnCzo4BCCNaiFUmQAEgATTcKJUMZckBK8adTwAtec0ctYrJPXvcYPi73mAqFIL607DLv+pCZAL4HFS7U8v5+E1XzTqeIDjhxolB7dbT/r3PYoUQEUUdCAWXs4752b5OIAkAHDRSHJ5OfH/6iEHUPjZTdMS+V7jzKYJnwfQWvnNwMNmFhkSCEEiIESJJCp34ycO22s4EVB5CMfBF/3OCe/6IkMhSAXEby8vdwk1XVkPVtMBIaS0cYwiMp8O6DxE0svBhiDppqQnAviVNYSK5ctHe5/+CYDorM5LeDl+OIBhaomAX9cXiPUFYv0nwB85ClgXV3TWkQAAAABJRU5ErkJggg==",
                "rel": "activation",
                "title": "Scan the code in BankID security app",
                "type": "image/png"
            }
        ],
        "metadata":
        {
            "viewName": "authenticator/bankid/wait/index"
        },
        "type": "polling-step",
        "properties":
        {
            "maxWaitTime": "60",
            "maxWaitRemainingTime": "57",
            "status": "pending"
        },
        "actions":
        [
            {
                "template": "form",
                "kind": "poll",
                "model":
                {
                    "href": "https://localhost:8443/dev/authn/authenticate/bankid1/poller",
                    "method": "GET"
                }
            },
            {
                "template": "client-operation",
                "kind": "login",
                "title": "Login with BankID",
                "model":
                {
                    "name": "bankid",
                    "arguments":
                    {
                        "href": "bankid:///?autostarttoken=2e76762e-920a-45e8-9b73-a50ef7513014&redirect=null",
                        "autoStartToken": "2e76762e-920a-45e8-9b73-a50ef7513014",
                        "redirect": "https://localhost:8443/dev/authn/authenticate/bankid1/poller"
                    },
                    "continueActions":
                    [
                        {
                            "template": "form",
                            "kind": "redirect",
                            "title": "If you are not redirected automatically, click here to continue authenticating",
                            "model":
                            {
                                "href": "https://localhost:8443/dev/authn/authenticate/bankid1/poller",
                                "method": "GET"
                            }
                        }
                    ]
                }
            },
            {
                "template": "form",
                "kind": "cancel",
                "title": "Cancel this operation",
                "model":
                {
                    "href": "https://localhost:8443/dev/authn/authenticate/bankid1/cancel",
                    "method": "POST",
                    "type": "application/x-www-form-urlencoded",
                    "actionTitle": "Cancel"
                }
            }
        ]
    }
    """
    // swiftlint:enable line_length
}

// MARK: - Generic

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {
    static let genericJSON: String = """
    {
        "links":
        [
            {
                "href": "/dev/authn/anonymous/duo1/info",
                "rel": "register-create",
                "title": "Register new device"
            }
        ],
        "metadata": {
            "viewName": "views/generic-representation/index"
        },
        "type": "authentication-step",
        "actions": [
            {
                "template": "selector",
                "kind": "authenticator-selector",
                "title": "Select Authentication Method",
                "model": {
                    "options": [
                        {
                            "template": "form",
                            "kind": "select-authenticator",
                            "title": "google1",
                            "properties": {
                                "authenticatorType": "google"
                            },
                            "model": {
                                "href": "/dev/authn/authenticate/google1",
                                "method": "GET"
                            }
                        },
                        {
                            "template": "form",
                            "kind": "select-authenticator",
                            "title": "username",
                            "properties": {
                                "authenticatorType": "username"
                            },
                            "model": {
                                "href": "/dev/authn/authenticate/username",
                                "method": "GET"
                            }
                        },
                        {
                            "template": "form",
                            "kind": "select-authenticator",
                            "title": "A standard SQL backed authenticator",
                            "properties":
                            {
                                "authenticatorType": "html-form"
                            },
                            "model":
                            {
                                "href": "/dev/authn/authenticate/htmlSql?__resumeUrl=%2Fdev%2Fauthn%2Fauthenticate%2Fgroup1",
                                "method": "GET"
                            }
                        }
                    ]
                }
            },
            {
                "template": "form",
                "kind": "bankid-other-device",
                "title": "Login with BankID installed on a different device",
                "model":
                {
                    "href": "https://localhost:8443/dev/authn/authenticate/bankid1/index",
                    "method": "POST",
                    "type": "application/x-www-form-urlencoded",
                    "actionTitle": "Login",
                    "fields":
                    [
                        {
                            "name": "personalnumber",
                            "type": "username",
                            "label": "Personal number",
                            "placeholder": "yyyymmddnnnn",
                            "value": "testuser"
                        },
                        {
                            "name": "usesamedevice",
                            "type": "hidden",
                            "value": "false"
                        }
                    ]
                }
            }
        ]
    }
    """
}

// MARK: - WebAuthn Registration

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {

    // swiftlint:disable line_length
    static let webAuthnRegistrationJSON: String = """
    {
        "links":
        [
            {
                "href": "/dev/authn/authenticate/webauthn",
                "rel": "restart",
                "title": "Return to login"
            }
        ],
        "metadata":
        {
            "viewName": "authenticator/webauthn/register/get"
        },
        "type": "registration-step",
        "actions":
        [
            {
                "template": "client-operation",
                "kind": "device-register",
                "title": "Register new device",
                "model":
                {
                    "name": "webauthn-registration",
                    "arguments":
                    {
                        "crossPlatformCredentialCreationOptions":
                        {
                            "publicKey":
                            {
                                "rp":
                                {
                                    "name": "se.curity",
                                    "id": "localhost"
                                },
                                "user":
                                {
                                    "name": "testuser",
                                    "displayName": "testuser",
                                    "id": "rl3rgi4NcZkpAEcacZnQ2VuOfJ0FxAqCRaKB_SwdZoQ"
                                },
                                "challenge": "bH_-vPwAMl0HSSXS5BGSw3RDi8OVqrSukfEKNSMEJdo",
                                "pubKeyCredParams":
                                [
                                    {
                                        "alg": -7,
                                        "type": "public-key"
                                    },
                                    {
                                        "alg": -257,
                                        "type": "public-key"
                                    }
                                ],
                                "excludeCredentials":
                                [
                                    {
                                        "type": "public-key",
                                        "id": "qyzYtsZ3fg0C3rByiLqYlHjt9VI"
                                    }
                                ],
                                "authenticatorSelection":
                                {
                                    "authenticatorAttachment": "cross-platform",
                                    "userVerification": "required",
                                    "requireResidentKey": false,
                                    "residentKey": "preferred"
                                },
                                "attestation": "none",
                                "extensions":
                                {}
                            }
                        },
                        "platformCredentialCreationOptions":
                        {
                            "publicKey":
                            {
                                "rp":
                                {
                                    "name": "se.curity",
                                    "id": "localhost"
                                },
                                "user":
                                {
                                    "name": "testuser",
                                    "displayName": "testuser",
                                    "id": "rl3rgi4NcZkpAEcacZnQ2VuOfJ0FxAqCRaKB_SwdZoQ"
                                },
                                "challenge": "iXHoHH1aZnVPd0L9kNsaghnTNSLBrSocuVNbo4ZhTMI",
                                "pubKeyCredParams":
                                [
                                    {
                                        "alg": -7,
                                        "type": "public-key"
                                    },
                                    {
                                        "alg": -257,
                                        "type": "public-key"
                                    }
                                ],
                                "excludeCredentials":
                                [],
                                "authenticatorSelection":
                                {
                                    "authenticatorAttachment": "platform",
                                    "userVerification": "preferred"
                                },
                                "attestation": "none",
                                "extensions":
                                {}
                            }
                        }
                    },
                    "continueActions":
                    [
                        {
                            "template": "form",
                            "kind": "continue",
                            "title": "Register new device",
                            "model":
                            {
                                "href": "https://localhost:8443/dev/authn/register/create/webauthn",
                                "method": "POST",
                                "type": "application/json",
                                "fields":
                                [
                                    {
                                        "name": "platformCredential",
                                        "type": "context"
                                    },
                                    {
                                        "name": "crossPlatformCredential",
                                        "type": "context"
                                    }
                                ]
                            }
                        }
                    ],
                    "errorActions":
                    [
                        {
                            "template": "form",
                            "kind": "redirect",
                            "model":
                            {
                                "href": "/dev/authn/authenticate/webauthn?_force_external_browser_flow=true",
                                "method": "GET"
                            }
                        }
                    ]
                }
            }
        ]
    }
    """
    // swiftlint:enable line_length
}

// MARK: - WebAuthn Authentication

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {

    // swiftlint:disable line_length
    static let webAuthnAuthenticationJSON: String = """
    {
        "links":
        [
            {
                "href": "https://localhost:8443/dev/authn/register/create/webauthn",
                "rel": "register-create",
                "title": "Register device"
            }
        ],
        "metadata":
        {
            "viewName": "authenticator/webauthn/authenticate-device/username"
        },
        "type": "authentication-step",
        "actions":
        [
            {
                "template": "client-operation",
                "kind": "login",
                "title": "Login with WebAuthn",
                "model":
                {
                    "name": "webauthn-authentication",
                    "arguments":
                    {
                        "credentialRequestOptions":
                        {
                            "publicKey":
                            {
                                "challenge": "uFHwD0tjjOpT9XKNsOp1VbrhQHsdepTGSLHJP6o6qlc",
                                "rpId": "localhost",
                                "allowCredentials":
                                [
                                    {
                                        "type": "public-key",
                                        "id": "2mipfIN5c22NELRdfY-4dPMEGv4"
                                    },
                                    {
                                        "type": "public-key",
                                        "id": "Bc3q-4mLIjrhPv3NCvW0ieGxe40"
                                    }
                                ],
                                "userVerification": "preferred",
                                "extensions":
                                {}
                            }
                        },
                        "platformCredentials":
                        [
                            {
                                "id": "2mipfIN5c22NELRdfY-4dPMEGv4",
                                "type": "public-key"
                            }
                        ],
                        "crossPlatformCredentials":
                        [
                            {
                                "id": "Bc3q-4mLIjrhPv3NCvW0ieGxe40",
                                "type": "public-key"
                            }
                        ]
                    },
                    "continueActions":
                    [
                        {
                            "template": "form",
                            "kind": "continue",
                            "title": "Login with WebAuthn",
                            "model":
                            {
                                "href": "https://localhost:8443/dev/authn/authenticate/webauthn",
                                "method": "POST",
                                "type": "application/json",
                                "fields":
                                [
                                    {
                                        "name": "credential",
                                        "type": "context"
                                    }
                                ]
                            }
                        }
                    ],
                    "errorActions":
                    [
                        {
                            "template": "form",
                            "kind": "redirect",
                            "model":
                            {
                                "href": "/dev/authn/authenticate/webauthn?_force_external_browser_flow=true",
                                "method": "GET"
                            }
                        }
                    ]
                }
            }
        ]
    }
    """
    // swiftlint:enable line_length
}

// MARK: - WebAuthn Additional Registration

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {

    // swiftlint:disable line_length
    static let webAuthnAdditionalRegistrationJSON: String = """
    {
        "messages": [
            {
                "text": "You just authenticated with a security key. Do you want to register an additional built-in device, such as face recognition or an embedded fingerprint reader?",
                "classList": ["info"]
            }
        ],
        "metadata": {
            "viewName": "authenticator/webauthn/add-additional-device/get"
        },
        "type": "authentication-step",
        "actions": [
            {
                "template": "client-operation",
                "kind": "device-register",
                "title": "Yes",
                "model": {
                    "name": "webauthn-registration",
                    "arguments": {
                        "platformCredentialCreationOptions": {
                            "publicKey": {
                                "rp": {"name": "example.com", "id": "example.com"},
                                "user": {"name": "user", "displayName": "user", "id": "abc123"},
                                "challenge": "AAAA",
                                "pubKeyCredParams": [{"alg": -7, "type": "public-key"}],
                                "excludeCredentials": [],
                                "authenticatorSelection": {
                                    "authenticatorAttachment": "platform",
                                    "userVerification": "required"
                                },
                                "attestation": "none",
                                "extensions": {}
                            }
                        }
                    },
                    "continueActions": [{
                        "template": "form",
                        "kind": "continue",
                        "title": "Yes",
                        "model": {
                            "href": "/authn/webauthn/add-additional-device",
                            "method": "POST",
                            "type": "application/json",
                            "fields": [{"name": "platformCredential", "type": "context"}]
                        }
                    }],
                    "errorActions": [{
                        "template": "form",
                        "kind": "continue",
                        "title": "No, not now",
                        "model": {
                            "href": "/authn/webauthn/add-additional-device",
                            "method": "POST",
                            "type": "application/x-www-form-urlencoded",
                            "actionTitle": "No, not now"
                        }
                    }]
                }
            },
            {
                "template": "form",
                "kind": "continue",
                "title": "Don't ask me again for this browser",
                "model": {
                    "href": "/authn/webauthn/add-additional-device",
                    "method": "POST",
                    "type": "application/x-www-form-urlencoded",
                    "fields": [{"name": "dont_ask_again_for", "type": "hidden", "value": "device"}]
                }
            }
        ]
    }
    """
    // swiftlint:enable line_length
}

// MARK: - WebAuthn Platform Only

@available(iOS 14.0, *)
extension HaapiPreviewDefaults {

    // swiftlint:disable line_length
    static let webAuthnPlatformOnlyJSON: String = """
    {
        "links":
        [
            {
                "href": "/dev/authn/authenticate/webauthn",
                "rel": "restart",
                "title": "Return to login"
            }
        ],
        "metadata":
        {
            "viewName": "authenticator/webauthn/register/get"
        },
        "type": "registration-step",
        "actions":
        [
            {
                "template": "client-operation",
                "kind": "device-register",
                "title": "Register new device",
                "model":
                {
                    "name": "webauthn-registration",
                    "arguments":
                    {
                        "platformCredentialCreationOptions":
                        {
                            "publicKey":
                            {
                                "rp":
                                {
                                    "name": "se.curity",
                                    "id": "localhost"
                                },
                                "user":
                                {
                                    "name": "testuser",
                                    "displayName": "testuser",
                                    "id": "rl3rgi4NcZkpAEcacZnQ2VuOfJ0FxAqCRaKB_SwdZoQ"
                                },
                                "challenge": "iXHoHH1aZnVPd0L9kNsaghnTNSLBrSocuVNbo4ZhTMI",
                                "pubKeyCredParams":
                                [
                                    {
                                        "alg": -7,
                                        "type": "public-key"
                                    },
                                    {
                                        "alg": -257,
                                        "type": "public-key"
                                    }
                                ],
                                "excludeCredentials":
                                [],
                                "authenticatorSelection":
                                {
                                    "authenticatorAttachment": "platform",
                                    "userVerification": "preferred"
                                },
                                "attestation": "none",
                                "extensions":
                                {}
                            }
                        }
                    },
                    "continueActions":
                    [
                        {
                            "template": "form",
                            "kind": "continue",
                            "title": "Register new device",
                            "model":
                            {
                                "href": "https://localhost:8443/dev/authn/register/create/webauthn",
                                "method": "POST",
                                "type": "application/json",
                                "fields":
                                [
                                    {
                                        "name": "platformCredential",
                                        "type": "context"
                                    }
                                ]
                            }
                        }
                    ],
                    "errorActions":
                    [
                        {
                            "template": "form",
                            "kind": "redirect",
                            "model":
                            {
                                "href": "/dev/authn/authenticate/webauthn?_force_external_browser_flow=true",
                                "method": "GET"
                            }
                        }
                    ]
                }
            }
        ]
    }
    """
    // swiftlint:enable line_length
}

#endif
