local mod = get_mod("pereqol")

mod:hook(HeroWindowWeaveProperties, "_magic_level", function(func,self) 
    return 30
end)