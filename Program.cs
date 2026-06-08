using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace GradientScreenSaver;

static class Program
{
    [STAThread]
    static void Main(string[] args)
    {
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);

        string mode = args.Length > 0 ? args[0].ToLower().TrimStart('/') : "s";

        if (mode == "c")
        {
            MessageBox.Show(
                "Gradient Screensaver\n\nA static gradient scene is generated each time it starts.\nMove mouse or click to exit.",
                "Gradient Screensaver", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        else if (mode.StartsWith("p"))
        {
            // preview mode: skip
        }
        else
        {
            foreach (Screen screen in Screen.AllScreens)
                new ScreenSaverForm(screen.Bounds).Show();
            Application.Run();
        }
    }
}

class ScreenSaverForm : Form
{
    static readonly Color[] Palette =
    {
        Color.FromArgb(250, 189,  47),
        Color.FromArgb(215, 153,  33),
        Color.FromArgb(254, 128,  25),
        Color.FromArgb(251,  73,  52),
        Color.FromArgb(184, 187,  38),
        Color.FromArgb(142, 192, 124),
        Color.FromArgb(131, 165, 152),
        Color.FromArgb( 69, 133, 136),
        Color.FromArgb(211, 134, 155),
        Color.FromArgb(146, 131, 116),
    };

    const float BlobSizeFactor = .90f;
    const float BlurFactor = .22f;
    const int FineGrainTileSize = 731;
    const int CoarseGrainTileSize = 1543;
    const int FineGrainAlpha = 12;
    const int CoarseGrainAlpha = 5;
    const int FineGrainContrast = 46;
    const int CoarseGrainContrast = 26;
    const float FineGrainOffsetX = -211f;
    const float FineGrainOffsetY = -397f;
    const float CoarseGrainOffsetX = -863f;
    const float CoarseGrainOffsetY = -541f;

    struct Blob
    {
        public float X, Y, R, Sx, Sy, Rot;
        public Color Current;
    }

    readonly Blob[]  _blobs     = new Blob[3];
    readonly Random  _rng       = new Random();
    Bitmap?   _buf;
    Bitmap?   _fineGrainTile;
    Bitmap?   _coarseGrainTile;
    TextureBrush? _fineGrainBrush;
    TextureBrush? _coarseGrainBrush;
    Graphics? _g;
    Point     _lastMouse;
    bool      _firstMove = true;

    public ScreenSaverForm(Rectangle bounds)
    {
        SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.UserPaint | ControlStyles.OptimizedDoubleBuffer, true);
        Bounds          = bounds;
        FormBorderStyle = FormBorderStyle.None;
        TopMost         = true;
        BackColor       = Color.Black;
        Cursor.Hide();

        InitBlobs();
    }

    void InitBlobs()
    {
        for (int i = 0; i < 3; i++)
        {
            var color = RandomColor();
            _blobs[i] = new Blob
            {
                X = NextFloat(-.12f, 1.12f),
                Y = NextFloat(-.10f, 1.10f),
                R = NextFloat(.86f, 1.08f),
                Sx = NextFloat(.85f, 1.38f),
                Sy = NextFloat(.78f, 1.28f),
                Rot = NextFloat(0f, 360f),
                Current = color,
            };
        }
    }

    Color RandomColor() => Palette[_rng.Next(Palette.Length)];

    float NextFloat(float min, float max) => min + (float)_rng.NextDouble() * (max - min);

    protected override void OnPaint(PaintEventArgs e)
    {
        int w = Width, h = Height;

        if (_buf == null || _buf.Width != w || _buf.Height != h)
        {
            _buf?.Dispose(); _g?.Dispose();
            _buf = new Bitmap(w, h);
            _g   = Graphics.FromImage(_buf);
            _g.SmoothingMode    = SmoothingMode.AntiAlias;
            _g.CompositingMode  = CompositingMode.SourceOver;
        }

        _g!.Clear(Color.FromArgb(40, 40, 40));

        int minDim = Math.Min(w, h);
        foreach (var b in _blobs)
        {
            float size = b.R * BlobSizeFactor * minDim;
            DrawBlob(b.X * w, b.Y * h, size, BlurFactor * minDim, b.Sx, b.Sy, b.Rot, b.Current);
        }
        ApplyFilmTexture(w, h);

        e.Graphics.DrawImageUnscaled(_buf, 0, 0);
    }

    void ApplyFilmTexture(int width, int height)
    {
        ApplyFilmTone(width, height);
        ApplyFilmGrain(width, height);
    }

    void ApplyFilmTone(int width, int height)
    {
        using var linear = new LinearGradientBrush(
            new Rectangle(0, 0, Math.Max(width, 1), Math.Max(height, 1)),
            Color.FromArgb(10, 251, 73, 52),
            Color.FromArgb(9, 69, 133, 136),
            135f);
        linear.InterpolationColors = new ColorBlend
        {
            Colors = new[]
            {
                Color.FromArgb(10, 251, 73, 52),
                Color.FromArgb(4, 184, 187, 38),
                Color.FromArgb(9, 69, 133, 136),
            },
            Positions = new[] { 0f, .45f, 1f }
        };
        _g!.FillRectangle(linear, 0, 0, width, height);

        using var path = new GraphicsPath();
        path.AddEllipse(width * -.25f, height * -.35f, width * 1.4f, height * 1.4f);
        using var radial = new PathGradientBrush(path)
        {
            CenterPoint = new PointF(width * .48f, height * .42f),
            CenterColor = Color.FromArgb(12, 250, 189, 47),
            SurroundColors = new[] { Color.FromArgb(0, 40, 40, 40) }
        };
        _g.FillPath(radial, path);
    }

    void ApplyFilmGrain(int width, int height)
    {
        if (_fineGrainBrush == null)
        {
            _fineGrainTile = CreateGrainTile(FineGrainTileSize, FineGrainAlpha, FineGrainContrast, 0x5E0A);
            _fineGrainBrush = new TextureBrush(_fineGrainTile, WrapMode.Tile);
            _fineGrainBrush.TranslateTransform(FineGrainOffsetX, FineGrainOffsetY);
        }
        if (_coarseGrainBrush == null)
        {
            _coarseGrainTile = CreateGrainTile(CoarseGrainTileSize, CoarseGrainAlpha, CoarseGrainContrast, 0xC0A4);
            _coarseGrainBrush = new TextureBrush(_coarseGrainTile, WrapMode.Tile);
            _coarseGrainBrush.TranslateTransform(CoarseGrainOffsetX, CoarseGrainOffsetY);
        }

        _g!.FillRectangle(_coarseGrainBrush, 0, 0, width, height);
        _g.FillRectangle(_fineGrainBrush, 0, 0, width, height);
    }

    static uint NextFilmGrainSeed(ref uint seed)
    {
        seed ^= seed << 13;
        seed ^= seed >> 17;
        seed ^= seed << 5;
        return seed;
    }

    static Bitmap CreateGrainTile(int size, int alpha, int contrast, uint seed)
    {
        var bmp = new Bitmap(size, size, PixelFormat.Format32bppPArgb);
        var rect = new Rectangle(0, 0, size, size);
        var data = bmp.LockBits(rect, ImageLockMode.WriteOnly, PixelFormat.Format32bppPArgb);
        try
        {
            int stride = data.Stride;
            var pixels = new byte[stride * size];
            uint state = seed == 0 ? 0x9e3779b9u : seed;

            for (int y = 0; y < size; y++)
            {
                int row = y * stride;
                for (int x = 0; x < size; x++)
                {
                    int raw = unchecked((byte)NextFilmGrainSeed(ref state));
                    int value = Math.Clamp(128 + ((raw - 128) * contrast / 128), 0, 255);
                    int premultiplied = value * alpha / 255;
                    int offset = row + x * 4;
                    pixels[offset] = (byte)premultiplied;
                    pixels[offset + 1] = (byte)premultiplied;
                    pixels[offset + 2] = (byte)premultiplied;
                    pixels[offset + 3] = (byte)alpha;
                }
            }

            Marshal.Copy(pixels, 0, data.Scan0, pixels.Length);
        }
        finally
        {
            bmp.UnlockBits(data);
        }

        return bmp;
    }

    void DrawBlob(float cx, float cy, float size, float blur, float sx, float sy, float rot, Color col)
    {
        float r = size / 2f + blur * 2f;
        var state = _g!.Save();
        _g.TranslateTransform(cx, cy);
        _g.RotateTransform(rot);
        _g.ScaleTransform(sx, sy);

        using var path  = new GraphicsPath();
        path.AddEllipse(-r, -r, r * 2, r * 2);
        using var brush = new PathGradientBrush(path) { CenterPoint = PointF.Empty };
        var blend = new ColorBlend(5);
        blend.Colors    = new[] { Color.FromArgb(0, col), Color.FromArgb(18, col), Color.FromArgb(66, col), Color.FromArgb(132, col), Color.FromArgb(178, col) };
        blend.Positions = new[] { 0f, .26f, .56f, .82f, 1f };
        brush.InterpolationColors = blend;
        _g.FillPath(brush, path);
        _g.Restore(state);
    }

    protected override void OnMouseMove(MouseEventArgs e)
    {
        if (_firstMove) { _lastMouse = e.Location; _firstMove = false; return; }
        if (Math.Abs(e.X - _lastMouse.X) > 10 || Math.Abs(e.Y - _lastMouse.Y) > 10)
            Application.Exit();
    }

    protected override void OnMouseDown(MouseEventArgs e) => Application.Exit();
    protected override void OnKeyDown(KeyEventArgs e)     => Application.Exit();

    protected override void OnFormClosed(FormClosedEventArgs e)
    {
        _fineGrainBrush?.Dispose(); _fineGrainTile?.Dispose();
        _coarseGrainBrush?.Dispose(); _coarseGrainTile?.Dispose();
        _buf?.Dispose(); _g?.Dispose();
        base.OnFormClosed(e);
    }
}
