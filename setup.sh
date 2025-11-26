#!/bin/bash

echo "🚀 Setting up Flutter E-Commerce Project..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

echo "✅ Flutter found"

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed"

# Run code generation
echo "🔧 Running code generation..."
flutter pub run build_runner build --delete-conflicting-outputs

if [ $? -ne 0 ]; then
    echo "❌ Code generation failed"
    exit 1
fi

echo "✅ Code generation completed"

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze

echo ""
echo "✅ Setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Configure Supabase credentials in lib/src/core/di/supabase_module.dart"
echo "2. Run 'flutter run' to start the app"
echo ""
echo "💡 Useful commands:"
echo "  - flutter pub run build_runner watch    # Watch for changes"
echo "  - flutter run                           # Run the app"
echo "  - flutter test                          # Run tests"
echo ""
