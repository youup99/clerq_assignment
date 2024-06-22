# Clerq Take-home Assignment!

# Code Structure
- All the code lives under `app` and `library`
- Using Rails Controller to expose this as an API

## How to test this out
1. Run `rails server`
2. Example requests
  - Terminal: `curl -X GET http://localhost:3000/settlement -d merchant=Weeks+Group+LLC -d date=2023-01-13`
  - Browser: `http://localhost:3000/settlement?merchant=Weeks+Group+LLC&date=2023-01-13`
    - Note: To see the parsed results, you are able to comment out this [line of code](https://github.com/youup99/clerq_assignment/blob/0d721b11f6e420ea7e5e97b8e266f339b3ccfc7e/app/controllers/settlement_controller.rb#L8)
  ![image](https://github.com/youup99/clerq_assignment/assets/35512076/e89a9e48-c6ec-47b8-b1f0-eb9f0342049f)
