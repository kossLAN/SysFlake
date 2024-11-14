{...}: {
  config = {
    programs.corectrl = {
      gpuOverclock = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };
  };
}
