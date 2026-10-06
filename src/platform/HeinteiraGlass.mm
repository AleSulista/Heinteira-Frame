#import <AppKit/AppKit.h>
#import <objc/runtime.h>
#include <QQuickWindow>
#include <QTimer>

namespace {
char glassKey;
void updateGlass(QQuickWindow *quick) {
    if (!quick->isVisible()) return;
    NSView *qtView = (__bridge NSView *)(void *)quick->winId();
    NSWindow *window = qtView.window;
    if (!window) return;
    const bool enabled = quick->color().alpha() == 0;
    NSVisualEffectView *glass = objc_getAssociatedObject(window, &glassKey);
    if (enabled && !glass) {
        NSView *original = window.contentView;
        NSView *container = [[NSView alloc] initWithFrame:original.frame];
        glass = [[NSVisualEffectView alloc] initWithFrame:container.bounds];
        glass.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        glass.material = NSVisualEffectMaterialSidebar;
        glass.blendingMode = NSVisualEffectBlendingModeBehindWindow;
        glass.state = NSVisualEffectStateFollowsWindowActiveState;
        window.contentView = container;
        [container addSubview:glass];
        original.frame = container.bounds;
        original.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [container addSubview:original];
        objc_setAssociatedObject(window, &glassKey, glass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    glass.hidden = !enabled;
    window.opaque = !enabled;
    window.backgroundColor = enabled ? NSColor.clearColor : NSColor.windowBackgroundColor;
    window.hasShadow = YES;
}
}
void installHeinteiraGlass(QQuickWindow *window) {
    QObject::connect(window, &QQuickWindow::colorChanged, window,
                     [window](const QColor &) { updateGlass(window); });
    QObject::connect(window, &QWindow::visibleChanged, window,
                     [window](bool) { QTimer::singleShot(0, window, [window] { updateGlass(window); }); });
    QTimer::singleShot(0, window, [window] { updateGlass(window); });
}
