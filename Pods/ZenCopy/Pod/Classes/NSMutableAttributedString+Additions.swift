public extension NSMutableAttributedString {
    public func regexFind(regex: String, addStyle styleName: String) {
        let style = Style()
        for styleName in ZenCopy.manager.styleNamesFromStyleString(styleName) {
            if let s = ZenCopy.manager.config.styles?(name: styleName) {
                style.append(s)
            }
        }
        regexFind(regex, addStyle: style)
    }
    
    public func regexFind(regex: String, addStyle style: Style) {
        regexFind(regex, style: style, replace: false)
    }
    
    public func regexFind(regex: String, setStyle style: String) {
        if let s = ZenCopy.manager.config.styles?(name: style) {
            regexFind(regex, setStyle: s)
        }
    }
    
    public func regexFind(regex: String, setStyle style: Style) {
        regexFind(regex, style: style, replace: true)
    }
    
    private func regexFind(regex: String, style: Style, replace: Bool) {
        do {
            let regularExpression = try NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions(rawValue: 0))
            let range = NSRange(location: 0, length: self.length)
            
            let matches = regularExpression.matchesInString(self.string, options: NSMatchingOptions(rawValue: 0), range: range)
            for match in matches {
                let range = match.range
                
                let attributes = ZenCopy.manager.attributesForStyle(style)
                if replace {
                    self.setAttributes(attributes, range: range)
                } else if let attributes = attributes {
                    self.addAttributes(attributes, range: range)
                }
            }
        } catch _ {
            
        }
    }
}
