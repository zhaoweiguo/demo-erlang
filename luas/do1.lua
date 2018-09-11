function doit(content)
    local json = require("luas.json");
    new = json.decode(content);
    new.name = "simon";
    new.age = 10;
    b = json.encode(new);
    print(b);
end
