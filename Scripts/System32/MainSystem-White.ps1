# X:\Windows\System32\MainSystem.ps1
# =============================================================================
# CORESYSTEM PREMIUM PRODUCTION GUI - HIGH CONTRAST LIGHT MODE & PIXEL CENTERED
# =============================================================================

$ProgressPreference = 'SilentlyContinue'

# 1. NAP THU VIEN SYSTEM WINDOWS FORMS & WPF
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# 2. WINAPI ĐỂ ĐIỀU KHIỂN VÀ CĂN GIỮA CỬA SỔ POWERSHELL
$WinAPI_Canvas = @"
using System;
using System.Runtime.InteropServices;
public class WinPEConsole {
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] [return: MarshalAs(UnmanagedType.Bool)] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    [DllImport("user32.dll")] public static extern int GetSystemMetrics(int nIndex);
    [DllImport("user32.dll")] [return: MarshalAs(UnmanagedType.Bool)] public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    [DllImport("user32.dll")] [return: MarshalAs(UnmanagedType.Bool)] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] [return: MarshalAs(UnmanagedType.Bool)] public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
    public struct RECT { public int Left; public int Top; public int Right; public int Bottom; }
}
"@
if (-not ([System.Management.Automation.PSTypeName]'WinPEConsole').Type) { Add-Type -TypeDefinition $WinAPI_Canvas }
Start-Sleep -Milliseconds 50
$hConsole = [WinPEConsole]::GetForegroundWindow()

# Ẩn cửa sổ PowerShell đen ban đầu ra khỏi tầm mắt ngay khi mở GUI Bạch Tuyết lên
if ($hConsole -ne [IntPtr]::Zero) {
    [WinPEConsole]::MoveWindow($hConsole, -2000, -2000, 300, 100, $true) | Out-Null
}

# Hàm ép kích thước Console bằng Pixel rộng rãi và căn thẳng vào giữa màn hình khi chạy tác vụ
function Set-ConsoleCentered {
    if ($hConsole -ne [IntPtr]::Zero) {
        # Ép cửa sổ về trạng thái Normal (SW_RESTORE = 9) để xóa trạng thái Maximized/Docked mặc định của WinPE
        [WinPEConsole]::ShowWindow($hConsole, 9) | Out-Null
        Start-Sleep -Milliseconds 50

        # Cấu hình cứng kích thước bằng Pixel thực tế (Rộng 920px, Cao 560px ~ Tương đương 110x28 ký tự chuẩn)
        $DesiredWidth  = 920
        $DesiredHeight = 560
        
        # Lấy độ phân giải màn hình thực tế lúc bấm nút
        $ScreenWidth  = [WinPEConsole]::GetSystemMetrics(0)
        $ScreenHeight = [WinPEConsole]::GetSystemMetrics(1)
        
        # Tính toán tọa độ tâm màn hình hoàn hảo
        $X = [Math]::Max(0, [int](($ScreenWidth - $DesiredWidth) / 2))
        $Y = [Math]::Max(0, [int](($ScreenHeight - $DesiredHeight) / 2))
        
        # Đặt lại Buffer cho PowerShell để nội dung chữ chạy mượt mà, không bị gãy dòng ngắn cũn
        try {
            $BufferSize = New-Object System.Management.Automation.Host.Size(120, 1500)
            $Host.UI.RawUI.BufferSize = $BufferSize
        } catch {}

        # Dùng SetWindowPos để vừa áp kích thước Pixel vừa ghim thẳng ra giữa màn hình
        [WinPEConsole]::SetWindowPos($hConsole, [IntPtr]::Zero, $X, $Y, $DesiredWidth, $DesiredHeight, 0x0040) | Out-Null
        [Console]::CursorVisible = $true
        Clear-Host
    }
}

# 3. MÃ NGUỒN XAML - BẠCH TUYẾT SÁNG TINH KHÔI (TƯƠNG PHẢN CAO)
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Main System"
        Height="490" Width="765"
        WindowStartupLocation="CenterScreen"
        Background="#F1F5F9"
        AllowsTransparency="False"
        WindowStyle="SingleBorderWindow"
        ResizeMode="NoResize"
        Foreground="#1E293B">

    <Window.Resources>
        <Style x:Key="BlueButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="#0284C7"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Height" Value="32"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="2,0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#0EA5E9"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter Property="Background" Value="#0369A1"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="DarkButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="#FFFFFF"/>
            <Setter Property="Foreground" Value="#000000"/>
            <Setter Property="BorderBrush" Value="#94A3B8"/>
            <Setter Property="BorderThickness" Value="1.2"/>
            <Setter Property="Height" Value="32"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="2,0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#F8FAFC"/>
                                <Setter Property="BorderBrush" Value="#0284C7"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter Property="Background" Value="#E2E8F0"/>
                                <Setter Property="BorderBrush" Value="#0369A1"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

        <Style x:Key="RedButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="#BE123C"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Height" Value="32"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="2,0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}"
                                BorderBrush="{TemplateBinding BorderBrush}"
                                BorderThickness="{TemplateBinding BorderThickness}"
                                CornerRadius="4">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="#E11D48"/>
                            </Trigger>
                            <Trigger Property="IsPressed" Value="True">
                                <Setter Property="Background" Value="#9F1239"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>

    <Grid Margin="12">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <Border Grid.Row="0" Background="#FFFFFF" BorderBrush="#94A3B8" BorderThickness="1.2" CornerRadius="6" Padding="12,8" Margin="0,0,0,10">
            <DockPanel>
                <TextBlock Text="CORESYSTEM" FontStyle="Normal" FontWeight="Bold" FontSize="18" Foreground="#0284C7" VerticalAlignment="Center"/>
                <TextBlock Text=" | ADVANCED OS DEPLOYMENT SYSTEM" FontSize="14" Foreground="#334155" FontWeight="Medium" VerticalAlignment="Center"/>
                <TextBlock Name="txtMode" Text="System Setup Mode" HorizontalAlignment="Right" VerticalAlignment="Center" Foreground="#B45309" FontWeight="Bold"/>
            </DockPanel>
        </Border>

        <Grid Grid.Row="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="4.3*"/>
                <ColumnDefinition Width="2.7*"/>
            </Grid.ColumnDefinitions>

            <GroupBox Grid.Column="0" Header=" CHỌN CHỨC NĂNG CẤU HÌNH " Margin="0,0,8,0" BorderBrush="#64748B" BorderThickness="1.5" Foreground="#0F172A" FontSize="13" FontWeight="Bold">
                <Grid Margin="6,4">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <Button Name="btnOSDCloudAuto" Grid.Row="0" Style="{StaticResource BlueButtonStyle}" FontWeight="Bold">
                        <TextBlock Text="1. Setup Windows Tự Động (Tweaks + Apps)" FontSize="12.5" Padding="12,0,0,0" VerticalAlignment="Center"/>
                    </Button>

                    <Button Name="btnOSDCloudClean" Grid.Row="1" Style="{StaticResource DarkButtonStyle}" FontWeight="SemiBold">
                        <TextBlock Text="2. Setup Windows (Nguyên bản Microsoft)" FontSize="12.5" Padding="12,0,0,0" VerticalAlignment="Center"/>
                    </Button>

                    <Button Name="btnExplorer" Grid.Row="2" Style="{StaticResource DarkButtonStyle}" FontWeight="SemiBold">
                        <TextBlock Text="3. Trình Quản Lý Tập Tin" FontSize="12.5" Padding="12,0,0,0" VerticalAlignment="Center"/>
                    </Button>

                    <Button Name="btnHardware" Grid.Row="3" Style="{StaticResource DarkButtonStyle}" FontWeight="SemiBold">
                        <TextBlock Text="4. Kiểm Tra Phần Cứng Máy Tính" FontSize="12.5" Padding="12,0,0,0" VerticalAlignment="Center"/>
                    </Button>

                    <Button Name="btnBackup" Grid.Row="4" Style="{StaticResource DarkButtonStyle}" FontWeight="SemiBold">
                        <TextBlock Text="5. Sao Lưu &amp; Khôi Phục Hệ Thống" FontSize="12.5" Padding="12,0,0,0" VerticalAlignment="Center"/>
                    </Button>

                    <Button Name="btnPartition" Grid.Row="5" Style="{StaticResource DarkButtonStyle}" FontWeight="SemiBold">
                        <TextBlock Text="6. Phân Vùng Ổ Đĩa" FontSize="12.5" Padding="12,0,0,0" VerticalAlignment="Center"/>
                    </Button>

                    <Button Name="btnWifi" Grid.Row="6" Style="{StaticResource DarkButtonStyle}" FontWeight="SemiBold">
                        <TextBlock Text="7. Kết Nối Mạng Wi-Fi" FontSize="12.5" Padding="12,0,0,0" VerticalAlignment="Center"/>
                    </Button>

                    <Button Name="btnReboot" Grid.Row="7" Style="{StaticResource RedButtonStyle}" FontWeight="Bold">
                        <TextBlock Text="8. Thoát &amp; Khởi Động Lại" FontSize="12.5" Padding="12,0,0,0" VerticalAlignment="Center"/>
                    </Button>
                </Grid>
            </GroupBox>

            <GroupBox Grid.Column="1" Header=" THÔNG TIN PHẦN CỨNG " Margin="8,0,0,0" BorderBrush="#64748B" BorderThickness="1.5" Foreground="#0F172A" FontSize="13" FontWeight="Bold">
                <Grid Margin="8,6">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>

                    <StackPanel Grid.Row="0" Margin="2">
                        <TextBlock Text="Boot Mode:" Foreground="#475569" FontSize="11" FontWeight="Bold" Margin="0,1,0,1"/>
                        <TextBlock Name="lblBootMode" Text="Detecting..." Foreground="#B45309" FontSize="13" FontWeight="Bold" Margin="0,0,0,5"/>

                        <TextBlock Text="Device Model:" Foreground="#475569" FontSize="11" FontWeight="Bold" Margin="0,1,0,1"/>
                        <TextBlock Name="lblModel" Text="Detecting..." Foreground="#000000" FontSize="11.5" FontWeight="SemiBold" Margin="0,0,0,5" TextTrimming="CharacterEllipsis"/>

                        <TextBlock Text="Processor (CPU):" Foreground="#475569" FontSize="11" FontWeight="Bold" Margin="0,1,0,1"/>
                        <TextBlock Name="lblCPU" Text="Detecting..." Foreground="#000000" FontSize="11.5" FontWeight="SemiBold" Margin="0,0,0,5" TextTrimming="CharacterEllipsis"/>

                        <TextBlock Text="Memory (RAM):" Foreground="#475569" FontSize="11" FontWeight="Bold" Margin="0,1,0,1"/>
                        <TextBlock Name="lblRAM" Text="Detecting..." Foreground="#047857" FontSize="13" FontWeight="Bold" Margin="0,0,0,5"/>

                        <TextBlock Text="Target Disk:" Foreground="#475569" FontSize="11" FontWeight="Bold" Margin="0,1,0,1"/>
                        <TextBlock Name="lblDisk" Text="Detecting..." Foreground="#0369A1" FontSize="11.5" FontWeight="Bold" Margin="0,0,0,8"/>

                        <Border BorderBrush="#94A3B8" BorderThickness="0,1.2,0,0" Padding="0,6,0,0">
                            <StackPanel>
                                <DockPanel Margin="0,0,0,4">
                                    <TextBlock Text="LAN Connection:" Foreground="#475569" FontSize="11" FontWeight="Bold"/>
                                    <TextBlock Name="lblLANIP" Text="Disconnected" Foreground="#0284C7" FontSize="12" FontWeight="Bold" HorizontalAlignment="Right"/>
                                </DockPanel>
                                <DockPanel>
                                    <TextBlock Text="Wi-Fi Net (IP):" Foreground="#475569" FontSize="11" FontWeight="Bold"/>
                                    <TextBlock Name="lblWifiIP" Text="Disconnected" Foreground="#0284C7" FontSize="12" FontWeight="Bold" HorizontalAlignment="Right"/>
                                </DockPanel>
                            </StackPanel>
                        </Border>
                    </StackPanel>

                    <Border Grid.Row="1" Background="#FFFFFF" BorderBrush="#94A3B8" BorderThickness="1.2" CornerRadius="4" Padding="6" Margin="0,2,0,0">
                        <StackPanel HorizontalAlignment="Center">
                            <TextBlock Name="lblSecureBoot" Text="SecureBoot: UNKNOWN" Foreground="#475569" FontSize="11" FontWeight="Bold" HorizontalAlignment="Center"/>
                            <TextBlock Name="lblTPM" Text="TPM 2.0: UNKNOWN" Foreground="#475569" FontSize="11" FontWeight="Bold" HorizontalAlignment="Center" Margin="0,2,0,0"/>
                        </StackPanel>
                    </Border>
                </Grid>
            </GroupBox>
        </Grid>

        <Border Grid.Row="2" Background="#FFFFFF" BorderBrush="#94A3B8" BorderThickness="1.2" CornerRadius="4" Padding="8" Margin="0,10,0,0">
            <Grid>
                <TextBlock Text="Shift + N [Notepad]          Shift + P [Powershell]" Foreground="#334155" FontWeight="Medium" VerticalAlignment="Center" FontSize="11" Padding="10,0,0,0"/>
                <TextBlock Text="www.coresystem.vn" Foreground="#0284C7" FontWeight="Bold" HorizontalAlignment="Right" VerticalAlignment="Center" FontSize="11" Padding="0,0,10,0"/>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

# 4. KHỞI TẠO ĐỐI TƯỢNG ĐỒ HỌA & ENGINE QUÉT PHẦN CỨNG NATIVE
$Reader = New-Object System.Xml.XmlNodeReader $XAML
$Form = [Windows.Markup.XamlReader]::Load($Reader)

$lblBootMode   = $Form.FindName("lblBootMode")
$lblModel      = $Form.FindName("lblModel")
$lblCPU        = $Form.FindName("lblCPU")
$lblRAM        = $Form.FindName("lblRAM")
$lblDisk       = $Form.FindName("lblDisk")
$lblLANIP      = $Form.FindName("lblLANIP")
$lblWifiIP     = $Form.FindName("lblWifiIP")
$lblSecureBoot = $Form.FindName("lblSecureBoot")
$lblTPM        = $Form.FindName("lblTPM")

function Refresh-Hardware-Specs {
    $lblBootMode.Text = if ($env:firmware_type -eq "UEFI") { "UEFI" } else { "Legacy/BIOS" }
    try {
        $Comp = Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue
        if ($Comp) { $lblModel.Text = $Comp.Model.Trim() } else { $lblModel.Text = "Generic PC" }

        $Proc = Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue
        if ($Proc) { $lblCPU.Text = $Proc.Name.Trim() } else { $lblCPU.Text = "Unknown CPU" }

        $OS = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        if ($OS) { $lblRAM.Text = "$([Math]::Round($OS.TotalVisibleMemorySize / 1024 / 1024)) GB" } else { $lblRAM.Text = "Unknown RAM" }
    } catch {
        $lblModel.Text = "Generic PC"; $lblCPU.Text = "Unknown CPU"; $lblRAM.Text = "Unknown RAM"
    }

    try {
        $Disks = Get-CimInstance Win32_DiskDrive -ErrorAction SilentlyContinue
        $TargetDisk = $Disks | Where-Object { $_.InterfaceType -ne "USB" -and $_.Model -notmatch "USB|TransMemory" } | Select-Object -First 1
        if (-not $TargetDisk) { $TargetDisk = $Disks | Select-Object -First 1 }
        if ($TargetDisk) { $lblDisk.Text = "$($TargetDisk.Model) ($([Math]::Round($TargetDisk.Size / 1GB)) GB)" } else { $lblDisk.Text = "No Target Disk Found" }
    } catch { $lblDisk.Text = "No Target Disk Found" }

    try {
        $LanConfig = Get-CimInstance Win32_NetworkAdapter | Where-Object { $_.NetConnectionID -match "Ethernet|LAN" }
        if ($LanConfig) {
            $LanIP = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.InterfaceIndex -eq $LanConfig.InterfaceIndex -and $_.IPEnabled }
            $lblLANIP.Text = if ($LanIP) { "$($LanIP.IPAddress[0])" } else { "Disconnected" }
        } else { $lblLANIP.Text = "No Hardware" }

        $WifiConfig = Get-CimInstance Win32_NetworkAdapter | Where-Object { $_.NetConnectionID -match "Wi-Fi|Wireless" }
        if ($WifiConfig) {
            $WifiIP = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.InterfaceIndex -eq $WifiConfig.InterfaceIndex -and $_.IPEnabled }
            $lblWifiIP.Text = if ($WifiIP) { "$($WifiIP.IPAddress[0])" } else { "Disconnected" }
        } else { $lblWifiIP.Text = "No Hardware" }
    } catch { $lblLANIP.Text = "Error"; $lblWifiIP.Text = "Error" }

    try {
        $SbState = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue
        if ($null -ne $SbState) {
            if ($SbState) { $lblSecureBoot.Text = "SecureBoot: ACTIVE"; $lblSecureBoot.Foreground = "#047857" }
            else { $lblSecureBoot.Text = "SecureBoot: DISABLED"; $lblSecureBoot.Foreground = "#B91C1C" }
        } else { $lblSecureBoot.Text = "SecureBoot: NOT SUPPORTED"; $lblSecureBoot.Foreground = "#475569" }
    } catch { $lblSecureBoot.Text = "SecureBoot: UNKNOWN" }

    try {
        $Tpm = Get-CimInstance -Namespace "Root\CIMv2\Security\MicrosoftTpm" -ClassName Win32_Tpm -ErrorAction SilentlyContinue
        if ($Tpm -and $Tpm.IsEnabled_InitialValue) { $lblTPM.Text = "TPM 2.0: DETECTED"; $lblTPM.Foreground = "#047857" }
        else { $lblTPM.Text = "TPM 2.0: NOT FOUND / DISABLED"; $lblTPM.Foreground = "#B91C1C" }
    } catch { $lblTPM.Text = "TPM 2.0: NOT FOUND"; $lblTPM.Foreground = "#B91C1C" }
}
Refresh-Hardware-Specs

# =============================================================================
# 5. ĐIỀU HƯỚNG SỰ KIỆN NÚT BẤM (MỚI - KHÔNG CO MÀN HÌNH)
# =============================================================================

# NUT SO 1: DEPLOY AUTO
$Form.FindName("btnOSDCloudAuto").add_Click({
    $Form.Close() 
    Set-ConsoleCentered
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "    CORESYSTEM - TIEN TRINH OSDCLOUD AUTO & INJECT      " -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Cyan
    
    Deploy-OSDCloud
    
    if (Test-Path "X:\Windows\System32\next-step.ps1") { 
        Write-Host "Dang thuc hien inject Unattend.xml & Post-setup sang o C..." -ForegroundColor Yellow
        & "X:\Windows\System32\next-step.ps1" 
    } else { 
        Write-Host "Khong tim thay script next-step.ps1!" -ForegroundColor Red
        pause 
    }
    Write-Host "Hoan tat nhiem vu. Bam phim bat ky de reboot..." -ForegroundColor Cyan
    pause
    wpeutil reboot
})

# NUT SO 2: DEPLOY WINDOWS SẠCH CHUẨN MS
$Form.FindName("btnOSDCloudClean").add_Click({
    $Form.Close()
    Set-ConsoleCentered
    Write-Host "========================================================" -ForegroundColor Cyan
    Write-Host "    CORESYSTEM - TIEN TRINH OSDCLOUD CLEAN (MICROSOFT)  " -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Cyan
    
    Deploy-OSDCloud
    
    Write-Host "OSDCloud nap thanh cong! He thong se tu dong reboot sau 5 giay..." -ForegroundColor Cyan
    Start-Sleep -Seconds 5
    wpeutil reboot
})

# NUT SO 3 -> 6: CHẠY CONCURRENT APPS GIỮ NGUYÊN FORM GUI
$Form.FindName("btnExplorer").add_Click({
    if (Test-Path "X:\Softwares\Explorer++\Explorer++.exe") { Start-Process "X:\Softwares\Explorer++\Explorer++.exe" }
})
$Form.FindName("btnHardware").add_Click({
    if (Test-Path "X:\Softwares\HWInfo\HWINFO64.exe") { Start-Process "X:\Softwares\HWInfo\HWINFO64.exe" }
})
$Form.FindName("btnBackup").add_Click({
    if (Test-Path "X:\Softwares\Multidrive\MultiDrive.exe") { Start-Process "X:\Softwares\Multidrive\MultiDrive.exe" }
})
$Form.FindName("btnPartition").add_Click({
    Start-Process "cmd.exe" -ArgumentList "/c diskpart.exe"
})

# NUT SO 7: WIFI CONFIGURATOR
$Form.FindName("btnWifi").add_Click({
    $Form.Hide()
    Set-ConsoleCentered
    powershell Invoke-WinPEStartupManager -id wifi
    
    Refresh-Hardware-Specs
    if ($hConsole -ne [IntPtr]::Zero) { [WinPEConsole]::MoveWindow($hConsole, -2000, -2000, 300, 100, $true) | Out-Null }
    $Form.ShowDialog() | Out-Null
})

# NUT SO 8: THOÁT & REBOOT
$Form.FindName("btnReboot").add_Click({
    $Form.Close()
    wpeutil reboot
})

# 6. BAN GLOBAL HOTKEY CHẠY NGẦM TRONG WINPE
$Form.add_KeyDown({
    param($sender, $e)
    if ([System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::LeftShift) -or [System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::RightShift)) {
        if ($e.Key -eq "N") { Start-Process notepad.exe }
        elseif ($e.Key -eq "P") {
            if (Get-Command pwsh.exe -ErrorAction SilentlyContinue) { Start-Process pwsh.exe }
            else { Start-Process powershell.exe }
        }
    }
})

# 7. CHẠY GIAO DIỆN CHÍNH
$Form.ShowDialog() | Out-Null
