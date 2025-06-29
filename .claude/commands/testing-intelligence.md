# Testing Intelligence Framework

Guidelines for Claude Code's intelligent Playwright testing decisions.

## Core Philosophy

**Test what matters, skip what doesn't.** Claude Code analyzes context to automatically run appropriate tests without slowing development.

## Decision Framework

### **Step 1: File Analysis**

Claude examines files created/modified during subtask implementation:

```typescript
function analyzeFilesForUIComponents(files: string[]): UIDetectionResult {
  const uiIndicators = {
    // Component files
    hasReactComponents: files.some(f => 
      f.includes('/components/') && f.endsWith('.tsx')
    ),
    
    // Page routes
    hasPageRoutes: files.some(f => 
      f.includes('/pages/') || 
      (f.includes('/app/') && f.endsWith('page.tsx'))
    ),
    
    // Form components
    hasFormElements: files.some(f => 
      f.match(/form|input|button|select|textarea/i)
    ),
    
    // UI libraries
    usesUIFramework: files.some(f => 
      f.includes('mui') || f.includes('chakra') || 
      f.includes('tailwind') || f.includes('styled')
    )
  };
  
  return {
    shouldTest: Object.values(uiIndicators).some(v => v),
    confidence: calculateConfidence(uiIndicators),
    testingRationale: generateRationale(uiIndicators)
  };
}
```

### **Step 2: Context Analysis**

Claude evaluates task/subtask descriptions for UI intent:

```typescript
const UI_KEYWORDS = [
  // Component indicators
  'component', 'ui', 'interface', 'widget', 'element',
  
  // Page indicators  
  'page', 'screen', 'view', 'layout', 'template',
  
  // Interaction indicators
  'form', 'button', 'input', 'click', 'submit', 'interact',
  
  // User-facing indicators
  'user', 'display', 'show', 'render', 'visible'
];

function hasUIIntent(description: string): boolean {
  const lower = description.toLowerCase();
  return UI_KEYWORDS.some(keyword => lower.includes(keyword));
}
```

### **Step 3: Critical Path Detection**

Some components always require testing:

```typescript
const CRITICAL_PATTERNS = {
  authentication: /login|signup|auth|password|session/i,
  payments: /payment|checkout|billing|stripe|subscription/i,
  dataEntry: /form|submit|save|create|update|delete/i,
  userDashboard: /dashboard|profile|settings|account/i
};

function isCriticalComponent(filePath: string, description: string): boolean {
  const content = filePath + ' ' + description;
  return Object.values(CRITICAL_PATTERNS).some(pattern => 
    pattern.test(content)
  );
}
```

## Testing Strategies

### **Minimal Testing (Default)**
For standard UI components - 30 seconds max:

```typescript
async function minimalUITest(componentPath: string) {
  // 1. Navigate to component
  await mcp__playwright__browser_navigate(`http://localhost:3000${componentPath}`);
  
  // 2. Wait for render
  await mcp__playwright__browser_wait_for({ time: 2 });
  
  // 3. Capture screenshot
  await mcp__playwright__browser_take_screenshot({
    filename: `test-${Date.now()}-component.png`
  });
  
  // 4. Basic interaction check
  const snapshot = await mcp__playwright__browser_snapshot();
  return snapshot.includes('error') ? 'failed' : 'passed';
}
```

### **Interactive Testing**
For forms and user input - 45 seconds max:

```typescript
async function interactiveTest(componentPath: string) {
  // 1. Minimal test first
  await minimalUITest(componentPath);
  
  // 2. Find interactive elements
  const snapshot = await mcp__playwright__browser_snapshot();
  
  // 3. Test primary interaction
  if (snapshot.includes('button')) {
    await mcp__playwright__browser_click({
      element: "primary button",
      ref: "button[type='submit']"
    });
  }
  
  // 4. Verify response
  await mcp__playwright__browser_wait_for({ time: 2 });
  
  // 5. Capture result
  await mcp__playwright__browser_take_screenshot({
    filename: `test-${Date.now()}-interaction.png`
  });
}
```

### **Critical Path Testing**
For auth/payments - 60 seconds max:

```typescript
async function criticalPathTest(componentPath: string, testType: string) {
  // Run interactive test first
  await interactiveTest(componentPath);
  
  // Additional validation based on type
  switch(testType) {
    case 'auth':
      await testAuthFlow();
      break;
    case 'payment':
      await testPaymentFlow();
      break;
    case 'form':
      await testFormValidation();
      break;
  }
}
```

## Intelligent Reporting

### **When Tests Run**

Claude adds detailed test results to Linear:

```typescript
function formatTestResults(results: TestResults): string {
  return `
🤖 Automated Testing Results:
${results.passed ? '✅' : '❌'} Component Testing: ${results.testType}
- Render test: ${results.renderTest}
- Interaction test: ${results.interactionTest}  
- Screenshot: ${results.screenshotUrl}
- Duration: ${results.duration}s
- Rationale: ${results.rationale}
`;
}
```

### **When Tests Skip**

Claude explains why testing wasn't needed:

```typescript
function formatSkipReason(reason: SkipReason): string {
  return `
🤖 Testing skipped:
- File type: ${reason.fileType}
- Reason: ${reason.explanation}
- Category: ${reason.category}
`;
}
```

## Decision Examples

### **Example 1: Login Component**
```
Files: components/auth/LoginForm.tsx
Task: "Create user login form"
Decision: TEST (critical auth component)
Strategy: Critical path testing with form validation
```

### **Example 2: Database Migration**
```
Files: migrations/add_user_table.sql
Task: "Add user database schema"  
Decision: SKIP (no UI component)
Reason: Backend infrastructure task
```

### **Example 3: Utility Function**
```
Files: utils/formatDate.ts
Task: "Create date formatting utilities"
Decision: SKIP (utility function)
Reason: No user interface involved
```

### **Example 4: Dashboard Page**
```
Files: app/dashboard/page.tsx
Task: "Build user dashboard"
Decision: TEST (new page route)
Strategy: Interactive testing with navigation
```

## Performance Considerations

### **Testing Time Budgets**
- Minimal tests: 30 seconds max
- Interactive tests: 45 seconds max  
- Critical tests: 60 seconds max
- Total per subtask: 60 seconds max

### **Resource Management**
```typescript
// Always clean up after tests
async function runTestWithCleanup(testFn: Function) {
  try {
    await testFn();
  } finally {
    // Close any open browsers
    await mcp__playwright__browser_close();
  }
}
```

### **Parallel Execution**
When multiple components need testing, Claude prioritizes:
1. Critical components first
2. User-facing pages second  
3. Standard components last
4. Skip if over time budget

## Override Commands

Users can control testing behavior:

```markdown
# Disable all automatic testing
"Skip all testing for this session"

# Force comprehensive testing
"Run full Playwright tests for all components"

# Test specific component
"Test the login form thoroughly"

# Skip specific test
"Skip testing for this utility function"
```

## Testing Output Format

### **Successful Test**
```
✅ ProfileCard component implemented
🤖 Auto-tested (38s):
  ✓ Renders user data correctly
  ✓ Handles missing avatar gracefully
  ✓ Click interaction works
  📸 Screenshot captured
```

### **Failed Test**
```
⚠️ CheckoutForm component implemented with issues
🤖 Auto-tested (45s):
  ✓ Component renders
  ✗ Form submission failed (console error)
  📸 Error screenshot captured
  Note: Implementation complete but needs debugging
```

### **Skipped Test**
```
✅ API endpoint created
🤖 No UI testing needed (backend task)
  Consider adding API integration tests separately
```

## Best Practices

1. **Keep tests lightweight** - Focus on smoke tests, not comprehensive validation
2. **Time-box execution** - Never let tests slow down development flow
3. **Capture evidence** - Screenshots prove functionality
4. **Explain decisions** - Always document why tested or skipped
5. **Non-blocking failures** - Log issues but continue workflow
6. **Clean up resources** - Close browsers and clean state

## Integration with Workflow

This testing intelligence integrates seamlessly with:
- **execute-tasks** - Tests run during subtask completion
- **linear-sync** - Test results included in progress updates
- **status updates** - Testing doesn't change task flow
- **git commits** - Test evidence referenced in commits

The goal: Intelligent quality assurance that enhances rather than hinders development velocity.