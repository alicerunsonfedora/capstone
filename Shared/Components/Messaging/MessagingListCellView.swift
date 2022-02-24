// 
//  MessagingListCellView.swift
//  Codename Shout
//
//  Created by Marquis Kurt on 23/2/22.
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

struct MessagingListCellView: View {

    @State var conversation: Conversation
    @State var currentUserID: String
    @State private var message = "Message content goes here."

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            conversationImage
            VStack(alignment: .leading) {
                HStack {
                    Text(getAuthors())
                        .bold()
                        .lineLimit(1)
                    Spacer()
                    if let status = conversation.lastStatus {
                        Text(
                            DateFormatter.mastodon.date(from: status.createdAt)!,
                            format: .relative(presentation: .named)
                        )
                            .foregroundColor(.secondary)
                            .font(.system(.footnote, design: .rounded))
                    }
                }
                Text(message)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .onAppear {
            Task {
                await loadStatus()
            }
        }
    }

    var conversationImage: some View {
        Group {
            if conversation.accounts.count > 2 {
                Image(systemName: "person.3.fill")
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .top, endPoint: .bottom)
                    )
            } else {
                if let person = conversation.accounts.last {
                    AsyncImage(url: URL(string: person.avatarStatic)!) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
        .clipShape(Circle())
        .frame(width: 40, height: 40)
    }

    private func getAuthors() -> String {
        if conversation.accounts.count <= 2 {
            return conversation.accounts.last { account in account.id != currentUserID }?.getAccountName() ?? "Person"
        }

        let firstTwoNames = Array(conversation.accounts.filter { account in account.id != currentUserID }[0..<2])
        let firstAuthors = firstTwoNames.reduce("") { text, account in
            text + "\(account.getAccountName()), "
        }

        let remainingText = String(
            format: NSLocalizedString("direct.grouptitle", comment: "remains"),
            conversation.accounts.count - 2
        )

        return firstAuthors + remainingText
    }

    private func loadStatus() async {
        guard let status = conversation.lastStatus else { return }
        message = await status.content.toPlainText()
    }
}

struct MessagingListCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingListCellView(conversation: MockData.conversation!, currentUserID: "0")
            .frame(width: 360, height: 120)
    }
}