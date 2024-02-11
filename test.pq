[Version = "1.0.0"]
section test;

[DataSource.Kind="test", Publish="test.Publish"]

shared test.Contents = (optional ApiKey as text) => 
    let
        BaseUrl = "https://api.orcasecurity.io/api/query/alerts",
        Headers = [
            #"authority" = "api.orcasecurity.io",
            #"accept" = "application/json, text/plain, */*",
            #"accept-language" = "en-US,en;q=0.9",
            #"authorization" = "TOKEN <Put-token-here>",
            #"content-type" = "application/json"
        ],
        
        Source = try Json.Document(Web.Contents(BaseUrl, [Headers = Headers])) otherwise error "Failed to fetch or parse JSON",
        Data = Source[data],
        DataTable = Table.FromRecords(Data)
        
    in
        DataTable;

test = [
    Authentication = [
        Key = []
    ]
];

// Data Source UI publishing description
test.Publish = [
    Beta = true,
    Category = "Other",
    ButtonText = { Extension.LoadString("ButtonTitle"), Extension.LoadString("ButtonHelp") },
    LearnMoreUrl = "https://powerbi.microsoft.com/",
    SourceImage = test.Icons,
    SourceTypeImage = test.Icons
];

test.Icons = [
    Icon16 = { Extension.Contents("test16.png"), Extension.Contents("test20.png"), Extension.Contents("test24.png"), Extension.Contents("test32.png") },
    Icon32 = { Extension.Contents("test32.png"), Extension.Contents("test40.png"), Extension.Contents("test48.png"), Extension.Contents("test64.png") }
];
