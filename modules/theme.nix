{ ... }: {
    programs.nixvim = {
        colorschemes.everforest = {
            enable = true;
            settings = {
                transparent_mode = true;
                background_color = "soft";
            };
        };

    };

}
