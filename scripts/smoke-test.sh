set -e

URL=$1
TIMEOUT=30
RETRY_DELAY=2
MAX_RETRIES=15

echo "🧪 Starting Smoke Test for $URL"
echo "================================"

# Function to check HTTP status
check_http_status() {
    local url=$1
    local expected_status=${2:-200}
    
    echo "Checking HTTP status for $url..."
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")
    
    if [ "$status" == "$expected_status" ]; then
        echo "✅ HTTP Status: $status (Expected: $expected_status)"
        return 0
    else
        echo "❌ HTTP Status: $status (Expected: $expected_status)"
        return 1
    fi
}

# Function to check response content
check_content() {
    local url=$1
    local search_term=$2
    
    echo "Checking content for '$search_term'..."
    response=$(curl -s "$url")
    
    if echo "$response" | grep -q "$search_term"; then
        echo "✅ Content check passed: Found '$search_term'"
        return 0
    else
        echo "❌ Content check failed: '$search_term' not found"
        return 1
    fi
}

# Wait for service to be ready
echo "Waiting for service to be ready..."
retries=0
while [ $retries -lt $MAX_RETRIES ]; do
    if curl -s -f "$URL" > /dev/null; then
        echo "✅ Service is ready!"
        break
    fi
    
    retries=$((retries + 1))
    echo "Attempt $retries/$MAX_RETRIES: Service not ready yet, waiting..."
    sleep $RETRY_DELAY
done

if [ $retries -eq $MAX_RETRIES ]; then
    echo "❌ Service failed to become ready after $MAX_RETRIES attempts"
    exit 1
fi

# Test 1: Homepage availability
echo ""
echo "Test 1: Homepage Availability"
echo "------------------------------"
check_http_status "$URL" 200 || exit 1

# Test 2: Content check
echo ""
echo "Test 2: Content Check"
echo "---------------------"
check_content "$URL" "root" || exit 1

# Test 3: Health endpoint (if exists)
echo ""
echo "Test 3: Health Endpoint"
echo "-----------------------"
if curl -s -f "$URL/health" > /dev/null 2>&1; then
    check_http_status "$URL/health" 200 || exit 1
else
    echo "ℹ️  Health endpoint not available (optional)"
fi

# Test 4: Response time
echo ""
echo "Test 4: Response Time"
echo "---------------------"
response_time=$(curl -s -o /dev/null -w "%{time_total}" "$URL")
response_time_ms=$(echo "$response_time * 1000" | bc)

echo "Response time: ${response_time_ms}ms"
if (( $(echo "$response_time < 2.0" | bc -l) )); then
    echo "✅ Response time is acceptable"
else
    echo "⚠️  Response time is slow (>${response_time_ms}ms)"
fi

echo ""
echo "================================"
echo "✅ All smoke tests PASSED!"
echo "================================"

exit 0