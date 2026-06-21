{ ... }: {
    programs.nixvim = {
        colorschemes.gruvbox-baby = {
            enable = true;
            settings = {
                transparent_mode = true;
                background_color = "soft";
            };
        };

    };
}
