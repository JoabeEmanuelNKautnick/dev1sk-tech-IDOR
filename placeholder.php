<?php
// Generate SVG placeholder images dynamically
$text = $_GET['text'] ?? 'Produto';
$color = $_GET['color'] ?? '1a75ff';

header('Content-Type: image/svg+xml');
header('Cache-Control: public, max-age=31536000');

echo '<?xml version="1.0" encoding="UTF-8"?>';
?>
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">
  <rect fill="#<?php echo htmlspecialchars($color); ?>" width="300" height="300"/>
  <text fill="white" x="50%" y="50%" text-anchor="middle" dy=".3em" font-family="Arial, sans-serif" font-size="32" font-weight="bold">
    <?php echo htmlspecialchars($text); ?>
  </text>
</svg>
