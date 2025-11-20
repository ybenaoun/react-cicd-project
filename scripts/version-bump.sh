VERSION_FILE="package.json"
CURRENT_VERSION=$(node -p "require('./package.json').version")

echo "Current version: $CURRENT_VERSION"
echo ""
echo "Select version bump type:"
echo "1) Patch (1.0.0 -> 1.0.1)"
echo "2) Minor (1.0.0 -> 1.1.0)"
echo "3) Major (1.0.0 -> 2.0.0)"
read -p "Enter choice [1-3]: " choice

case $choice in
    1) npm version patch ;;
    2) npm version minor ;;
    3) npm version major ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

NEW_VERSION=$(node -p "require('./package.json').version")
echo ""
echo "Version bumped to: $NEW_VERSION"
echo "Creating git tag: v$NEW_VERSION"

git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"
echo "✅ Tag created successfully"
echo ""
echo "Push with: git push origin v$NEW_VERSION"