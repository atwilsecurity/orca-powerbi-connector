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
            #"authorization" = "TOKEN <add-your-token-here",
            #"content-type" = "application/json"
        ],
        
        // Function to recursively fetch pages
        FetchAllPages = (Url, AccumulatedData as list, optional NextPageToken as text) =>
            let
                PageUrl = if NextPageToken = null then Url else Url & "?next_page_token=" & Text.From(NextPageToken),
                PageSource = Json.Document(Web.Contents(PageUrl, [Headers = Headers])),
                PageData = PageSource[data],
                NewAccumulatedData = AccumulatedData & PageData,
                NextToken = if PageSource[has_next_page_token] = false then null else PageSource[next_page_token], // Assuming nextPageToken is the key for pagination
                Result = if NextToken <> null then @FetchAllPages(Url, NewAccumulatedData, NextToken) else NewAccumulatedData
                in
                    Result,
            
        AllData = FetchAllPages(BaseUrl, {}),
        DataTable = Table.FromRecords(AllData)
        
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
