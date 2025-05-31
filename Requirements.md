
# Project Core Requirements

https://d3jbb8n5wk0qxi.cloudfront.net/take-home-project.html

## Functional Requirements

[X] Use SwiftUI
[X] Display recipes using data from the provided API.
[X] At a minimum, each recipe should show its name, photo, and cuisine type. You’re welcome to display additional details, add features, or sort the recipes in any way you see fit.
[X] The app should consist of at least one screen displaying a list of recipes.
[X] Allow users to refresh the recipe list at any time.
[X] Handle error cases:
    Malformed data: Ignore all recipes and show an error state.
    Empty data: Show an empty state indicating no recipes are available.
[X] Include a README
[X] Include unit tests focusing on core logic like data fetching and caching. UI Tests not required.
    
## Project Constraints

- Load images only when needed.
- Implement custom image caching to disk (avoid URLSession's HTTP cache and URLCache).
- No AI-generated code (like ChatGPT or Copilot).
- Minimum supported iOS version possible, Fetch supports iOS 16+.
- Swift Concurrency: Use async/await for all asynchronous operations, including API calls and image loading.
- No External Dependencies: Only use Apple's frameworks—no third-party libraries for UI, networking, image caching, or testing.

---

## Implementation details:

- All recipes: https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json
- Malformed data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
- Empty data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
 
### Expected JSON Structure for recipes:
* Non-optional values in json are labeled below
```JSON
{
    "recipes": [
        {
            "cuisine": "British", (*required)
            "name": "Bakewell Tart", (*required)
            "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6", (*required)
            "photo_url_large": "https://some.url/large.jpg",
            "photo_url_small": "https://some.url/small.jpg",
            "source_url": "https://some.url/index.html",
            "youtube_url": "https://www.youtube.com/watch?v=some.id"
        },
        ...
    ]
}
```
