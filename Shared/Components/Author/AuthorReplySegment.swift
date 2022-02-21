// 
//  AuthorReplySegment.swift
//  Codename Shout
//
//  Created by Marquis Kurt on 17/2/22.
//
//  This file is part of Codename Shout.
//
//  Codename Shout is non-violent software: you can use, redistribute, and/or modify it under the terms of the CNPLv7+
//  as found in the LICENSE file in the source code root directory or at <https://git.pixie.town/thufie/npl-builder>.
//
//  Codename Shout comes with ABSOLUTELY NO WARRANTY, to the extent permitted by applicable law. See the CNPL for
//  details.

import Foundation
import SwiftUI
import Chica

struct AuthorReplySegment: View {

    @State var reply: Status
    @State private var promptContent = ""

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: "text.bubble")
                .foregroundColor(.accentColor)
            VStack(alignment: .leading, spacing: 4) {
                Text(
                    String(
                        format: NSLocalizedString("status.replytext", comment: "reply"),
                        reply.account.getAccountName() + " (@\(reply.account.acct))"
                    )
                )
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(.accentColor)
                    .bold()
                Text(promptContent)
                    .lineLimit(3)
            }
            .foregroundColor(.secondary)
            .onAppear {
                Task {
                    promptContent = await reply.content.toPlainText()
                }
            }
        }
    }
}