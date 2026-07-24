import SwiftUI

struct ModelDetailView: View {
    let author: String
    let slug: String
    
    @StateObject private var viewModel = ModelDetailViewModel()
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
            } else if let data = viewModel.data {
                VStack(spacing: 32) {
                    AsyncImage(url: URL(string: "https://img.icons8.com/color/512/bard.png")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 64, height: 64)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    VStack(spacing: 8) {
                        Text(data.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(data.id)
                            .font(.subheadline)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(.gray.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("DESCRIPTION")
                            .font(.footnote)
                        Text(data.description)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("TECHNICAL SPECIFICATIONS")
                            .font(.footnote)
                        HStack {
                            Image(systemName: "cpu")
                                .font(.system(size: 18))
                                .foregroundStyle(.blue)
                                .frame(width: 32, height: 32)
                                .background(.blue.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            Text("\(data.contextLength) Context Length")
                                .font(.callout)
                        }
                        HStack {
                            Image(systemName: "text.line.2.summary")
                                .font(.system(size: 18))
                                .foregroundStyle(.red)
                                .frame(width: 32, height: 32)
                                .background(.red.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            Text(data.architecture.modality ?? "-")
                                .font(.callout)
                        }
                        HStack {
                            Image(systemName: "dollarsign")
                                .font(.system(size: 18))
                                .foregroundStyle(.green)
                                .frame(width: 32, height: 32)
                                .background(.green.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            Text("Pricing")
                                .font(.callout)
                        }
                        HStack {
                            Text("")
                                .font(.system(size: 18))
                                .frame(width: 32, height: 32)
                            VStack(alignment: .leading) {
                                if let completion = data.pricing.completion {
                                    Text("$\(completion)")
                                        .font(.callout)
                                }
                                if let image = data.pricing.image {
                                    Text("\(image)")
                                        .font(.callout)
                                }
                                if let prompt = data.pricing.prompt {
                                    Text("$\(prompt)")
                                        .font(.callout)
                                }
                                if let request = data.pricing.request {
                                    Text("$\(request)")
                                        .font(.callout)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else if let error = viewModel.errorMessage {
                VStack(alignment: .leading, spacing: 16) {
                    Text(error)
                        .font(.footnote)
                }
            }
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemBackground))
        .task {
            await viewModel.fetchModelDetail(author: author, slug: slug)
        }
        .navigationTitle("Details")
    }
}

#Preview {
    ModelDetailView(author: "microsoft", slug: "mai-image-2.5-pro")
}
