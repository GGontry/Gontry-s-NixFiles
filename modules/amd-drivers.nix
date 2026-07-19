{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.minecraft-streamer;
in {
  options.modules.minecraft-streamer = {
    enable = mkEnableOption "Entorno óptimo para Minecraft Técnico y Streaming";
  };

  config = mkIf cfg.enable {
    # 1. DRIVERS GRÁFICOS Y ACELERACIÓN
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd    
        libvdpau-va-gl          
      ];
    };

    # 2. GESTIÓN DE MEMORIA AVANZADA (Para los 32GB DDR4)
    # Comprime la memoria al vuelo usando Zstandard (rapidísimo en el 5600G)
    zramSwap = {
      enable = true;
      memoryPercent = 50; 
      algorithm = "zstd"; 
    };

    # 3. ESTABILIDAD DE RED Y AFINACIÓN DEL KERNEL
    boot.kernelModules = [ "tcp_bbr" ];
    boot.kernel.sysctl = {
      # --- Red ---
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_rmem" = "4096 87380 16777216";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.tcp_mtu_probing" = 1; 
      
      # --- Memoria y Disco ---
      "vm.max_map_count" = 1048576; # Evita cuelgues con granjas/perímetros masivos
      
      # Optimización para ZRAM: animar al sistema a usar la RAM comprimida
      "vm.swappiness" = 150;
      "vm.watermark_scale_factor" = 200; # Empieza a usar ZRAM cuando queden ~650MB libres
      "vm.vfs_cache_pressure" = 50;      # Retiene cachés de archivos en RAM
      
      # Prevención de "Lag Spikes" al guardar al disco
      "vm.dirty_background_ratio" = 1;   # Escribe silenciosamente al 1%
      "vm.dirty_ratio" = 3;              # Límite duro al 3%
    };

    # 4. BLINDAJE PARA OBS Y CAPTURAS
    security.rtkit.enable = true;

    security.pam.loginLimits = [
      { domain = "*"; type = "-"; item = "nofile"; value = "524288"; }
    ];

    # Entorno declarativo de OBS
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi           # Codificador H.264/HEVC para la 6750 XT
        wlrobs              
        obs-vkcapture       
        obs-pipewire-audio-capture
	obs-aitum-multistream
	obs-vertical-canvas
      ];
    };

    # 5. GESTIÓN DEL PROCESADOR (Ryzen 5600G + RX 6750 XT)
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 5; 
        };
        # Forzar GPU de máximo rendimiento (la 6750 XT)
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1; # Cambiar a 0 si Hyprland/Niri/OBS toman la integrada por error
          amd_performance_level = "high";
        };
      };
    };
  };
}
