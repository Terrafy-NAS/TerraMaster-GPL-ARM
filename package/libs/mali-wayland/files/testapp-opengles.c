#include <linux/fb.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <stdint.h>
#include <sys/mman.h>
#include <unistd.h>

#include <GLES3/gl3.h>
#include <EGL/egl.h>

#define swap16(x) ({						\
	u_int16_t __swap16gen_x = (x);					\
									\
	(u_int16_t)((__swap16gen_x & 0xff) << 8 |			\
	    (__swap16gen_x & 0xff00) >> 8);				\
})

#define pattern swap16((0x0 << 11 | 0x0 << 5 | 0x1f)) //RGB565	
//#define pattern swap16((0x01<<15 | 0x00 << 10 | 0x1f << 5 | 0x0)) //ARGB
//#define pattern swap16((0x1f<<11 | 0x1f << 6 | 0x1f << 1 | 0x0))	//RGBA
#define ALPHA_VALUE 0x80
const char *FB_NAME = "/dev/fb0";
void*   m_FrameBuffer;
struct  fb_fix_screeninfo m_FixInfo;
struct  fb_var_screeninfo m_VarInfo;
int	m_FBFD;
enum dc_buffer_flags {
	eBuffer_AFBC_Enable            = 0x1U << 16,
	eBuffer_AFBC_Split             = 0x1U << 17,
	eBuffer_AFBC_YUV_Transform     = 0x1U << 18,
};
enum dc_buffer_id {
	eFrameBuffer            = 0x1U << 0,
	eFrameBufferSkip        = 0x1U << 4,
	eIONBuffer              = 0x1U << 1,
	eUserBurrer             = 0x1U << 2,
	eFrameBufferTarget      = 0x1U << 3,
};

enum dc_overlay_engine {
	eEngine_VO              = 0x1U << 0,
	eEngine_SE              = 0x1U << 1,
	eEngine_DMA             = 0x1U << 2,
	eEngine_MAX             = 0x1U << 3,
};

typedef enum
{
  INBAND_CMD_GRAPHIC_FORMAT_RGB565            = 4,    /* 16-bit RGB    (565)  with constant alpha */
  INBAND_CMD_GRAPHIC_FORMAT_ARGB1555          = 5,    /* 16-bit ARGB   (1555) */
  INBAND_CMD_GRAPHIC_FORMAT_ARGB8888          = 7,    /* 32-bit ARGB   (8888) */
  INBAND_CMD_GRAPHIC_FORMAT_RGBA5551          = 13,   /* 16-bit RGBA   (5551) */
  INBAND_CMD_GRAPHIC_FORMAT_RGBA8888          = 15,   /* 32-bit RGBA   (8888) */
  INBAND_CMD_GRAPHIC_FORMAT_RGB888            = 22,   /* 24-bit RGB    (888)  with constant alpha */
  INBAND_CMD_GRAPHIC_FORMAT_RGB565_LITTLE     = 36,   /* litttle endian below */
  INBAND_CMD_GRAPHIC_FORMAT_ARGB1555_LITTLE   = 37,
  INBAND_CMD_GRAPHIC_FORMAT_ARGB8888_LITTLE   = 39,
  INBAND_CMD_GRAPHIC_FORMAT_RGBA5551_LITTLE   = 45,
  INBAND_CMD_GRAPHIC_FORMAT_RGBA8888_LITTLE   = 47,
  INBAND_CMD_GRAPHIC_FORMAT_RGB888_LITTLE     = 54
} INBAND_CMD_GRAPHIC_FORMAT ;

#define DC2VO_IOC_MAGIC        'd'
#define DC2VO_IOC_MAXNR        32
#define DC2VO_WAIT_FOR_VSYNC             _IO    (DC2VO_IOC_MAGIC,  0)
#define DC2VO_SET_BUFFER_ADDR            _IO    (DC2VO_IOC_MAGIC,  1)
#define DC2VO_GET_BUFFER_ADDR            _IO    (DC2VO_IOC_MAGIC,  2)
#define DC2VO_SET_RING_INFO              _IO    (DC2VO_IOC_MAGIC,  3)
#define DC2VO_SET_OUT_RATE_INFO          _IO    (DC2VO_IOC_MAGIC,  4)
#define DC2VO_SET_DISABLE                _IO    (DC2VO_IOC_MAGIC,  5)
#define DC2VO_GET_SURFACE                _IO    (DC2VO_IOC_MAGIC,  6)
#define DC2VO_SET_MODIFY                 _IO    (DC2VO_IOC_MAGIC,  7)
#define DC2VO_GET_MAX_FRAME_BUFFER       _IO    (DC2VO_IOC_MAGIC,  8)
#define DC2VO_GET_SYSTEM_TIME_INFO       _IO    (DC2VO_IOC_MAGIC,  9)
#define DC2VO_SET_SYSTEM_TIME_INFO       _IO    (DC2VO_IOC_MAGIC, 10)
#define DC2VO_GET_CLOCK_MAP_INFO         _IO    (DC2VO_IOC_MAGIC, 11)
#define DC2VO_GET_CLOCK_INFO             _IO    (DC2VO_IOC_MAGIC, 12)
#define DC2VO_RESET_CLOCK_TABLE          _IO    (DC2VO_IOC_MAGIC, 13)
#define DC2VO_SET_ION_SHARE_MEMORY       _IO    (DC2VO_IOC_MAGIC, 17)
#define DC2VO_SET_BUFFER_INFO            _IO    (DC2VO_IOC_MAGIC, 18)
#define DC2VO_SET_BG_SWAP                _IO    (DC2VO_IOC_MAGIC, 19)
#define DC2VO_SET_GLOBAL_ALPHA           _IO    (DC2VO_IOC_MAGIC, 20)
#define DC2VO_SET_VSYNC_FORCE_LOCK       _IO    (DC2VO_IOC_MAGIC, 21)
#define DC2VO_SIMPLE_POST_CONFIG         _IO    (DC2VO_IOC_MAGIC, 22)
#define USE_GLOBAL_ALPHA	1<<19
struct dc_buffer_rect {
	unsigned int left;
	unsigned int top;
	unsigned int right;
	unsigned int bottom;
};

struct dc_buffer {
	unsigned int            id;                 /* enum dc_buffer_id */
	unsigned int            overlay_engine;     /* enum dc_overlay_engine */
	struct dc_buffer_rect   sourceCrop;
	struct dc_buffer_rect   displayFrame;       /* base on framebuffer */
	unsigned int            format;
	unsigned int            offset;
	unsigned int            phyAddr;
	unsigned int            width;
	unsigned int            height;
	unsigned int            stride;
	unsigned int            context;
	int64_t                 pts;
	unsigned int            flags;
    unsigned int            plane_alpha; 
    unsigned int            colorkey; 
	unsigned int            reserve[30];
	int64_t                 acquire_fence_fd;   /* user   space : fenceFd (input) */
};
struct dc_simple_post_config {
	struct dc_buffer        buf;
	int                     complete_fence_fd;
};

GLubyte* pixeldata;
GLuint imagewidth,imageheight,pixellength;

static const EGLint pbufferAttribs[] = {
	EGL_WIDTH, 1920,  //800
	EGL_HEIGHT, 1080, //600
	EGL_NONE,
};

static const EGLint configAttribs[] = {
	EGL_SURFACE_TYPE, EGL_PBUFFER_BIT,
	EGL_BLUE_SIZE, 8,
	EGL_GREEN_SIZE, 8,
	EGL_RED_SIZE, 8,
	EGL_DEPTH_SIZE, 8,
	EGL_RENDERABLE_TYPE, EGL_OPENGL_ES2_BIT,
	EGL_NONE
}; 

static const EGLint contextAttribs[] = {
	EGL_CONTEXT_CLIENT_VERSION, 2,
	EGL_NONE
};

float vertices_fore[] = {
    // positions          // colors                // texture coords
    0.5f,  0.5f, 0.0f,   1.0f, 0.0f, 0.0f, 1.0f,   1.0f, 1.0f, // top right
    0.5f, -0.5f, 0.0f,   0.0f, 1.0f, 0.0f, 1.0f,   1.0f, 0.0f, // bottom right
   -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f, 1.0f,   0.0f, 0.0f, // bottom left
   -0.5f,  0.5f, 0.0f,   1.0f, 1.0f, 0.0f, 1.0f,   0.0f, 1.0f  // top left 
 };

float vertices_back[] = {
    // positions          // colors                // texture coords
    1.0f,  1.0f, 0.0f,   1.0f, 0.0f, 0.0f, 1.0f,   1.0f, 1.0f, // top right
    1.0f, -1.0f, 0.0f,   0.0f, 1.0f, 0.0f, 1.0f,   1.0f, 0.0f, // bottom right
   -1.0f, -1.0f, 0.0f,   0.0f, 0.0f, 1.0f, 1.0f,   0.0f, 0.0f, // bottom left
   -1.0f,  1.0f, 0.0f,   1.0f, 1.0f, 0.0f, 1.0f,   0.0f, 1.0f  // top left 
 };

unsigned int indices[] = {
    0, 1, 3, // first triangle
    1, 2, 3  // second triangle
};

const char *vertexShaderSource = "#version 320 es\n"
    "layout (location = 0) in vec3 aPos;\n"
    "layout (location = 1) in vec4 aColor;\n"
    "layout (location = 2) in vec2 aTexCoord;\n"
    "out vec4 ourColor;\n"
    "out vec2 TexCoord;\n"
    "void main()\n"
    "{\n"
    "    gl_Position = vec4(aPos, 1.0);\n"
    "    ourColor = aColor;\n"
    "    TexCoord = aTexCoord;\n"
    "}\0";

const char *fragmentShaderSource = "#version 320 es\n"
    "precision mediump float;\n"
    "out vec4 FragColor;\n"
    "in vec4 ourColor;\n"
    "in vec2 TexCoord;\n"
    "uniform sampler2D ourTexture;\n"
    "void main()\n"
    "{\n"
    "   FragColor = texture(ourTexture, TexCoord);\n"
    "}\n\0";


static const char* eglGetErrorStr(){
	switch(eglGetError()){
		case EGL_SUCCESS: return "The last function succeeded without error.";
		case EGL_NOT_INITIALIZED: return "EGL is not initialized, or could not be initialized, for the specified EGL display connection.";
		case EGL_BAD_ACCESS: return "EGL cannot access a requested resource (for example a context is bound in another thread).";
		case EGL_BAD_ALLOC: return "EGL failed to allocate resources for the requested operation.";
		case EGL_BAD_ATTRIBUTE: return "An unrecognized attribute or attribute value was passed in the attribute list.";
		case EGL_BAD_CONTEXT: return "An EGLContext argument does not name a valid EGL rendering context.";
		case EGL_BAD_CONFIG: return "An EGLConfig argument does not name a valid EGL frame buffer configuration.";
		case EGL_BAD_CURRENT_SURFACE: return "The current surface of the calling thread is a window, pixel buffer or pixmap that is no longer valid.";
		case EGL_BAD_DISPLAY: return "An EGLDisplay argument does not name a valid EGL display connection.";
		case EGL_BAD_SURFACE: return "An EGLSurface argument does not name a valid surface (window, pixel buffer or pixmap) configured for GL rendering.";
		case EGL_BAD_MATCH: return "Arguments are inconsistent (for example, a valid context requires buffers not supplied by a valid surface).";
		case EGL_BAD_PARAMETER: return "One or more argument values are invalid.";
		case EGL_BAD_NATIVE_PIXMAP: return "A NativePixmapType argument does not refer to a valid native pixmap.";
		case EGL_BAD_NATIVE_WINDOW: return "A NativeWindowType argument does not refer to a valid native window.";
		case EGL_CONTEXT_LOST: return "A power management event has occurred. The application must destroy all contexts and reinitialise OpenGL ES state and objects to continue rendering.";
		default: break;
	}
	return "Unknown error!";
}

// Get RGBA-image
void getPictures(){
	GLubyte* pixelimg;

	FILE* pfile=fopen("1015.bmp","rb");
	if(pfile == 0) exit(0);
	fseek(pfile,18,SEEK_SET);
	fread(&imagewidth,sizeof(imagewidth),1,pfile);
	fread(&imageheight,sizeof(imageheight),1,pfile);
	pixellength=imagewidth*4;
	while(pixellength%4 != 0) pixellength++;

	pixellength *= imageheight;
	pixeldata = (GLubyte*)malloc(pixellength);
	pixelimg = (GLubyte*)malloc(pixellength);
	if(pixelimg == 0) exit(0);
	fseek(pfile, 54,SEEK_SET);
	fread(pixelimg,pixellength,1,pfile);

	for(int i =0; i < imageheight; i++) {
		for(int j = 0; j < imagewidth; j++) {
			memcpy(pixeldata+imagewidth*(imageheight-1-i)*4+4*j, pixelimg+i*imagewidth*4+j*4, 4);
		}
	}

	fclose(pfile);
}

int opengles_test() {
	EGLDisplay display;
	int major, minor;

	getPictures();

	// Create EGL
	if((display = eglGetDisplay(EGL_DEFAULT_DISPLAY)) == EGL_NO_DISPLAY){
		fprintf(stderr, "Failed to get EGL display! Error: %s\n", eglGetErrorStr());
		return EXIT_FAILURE;
	}

	if(eglInitialize(display, &major, &minor) == EGL_FALSE){
		fprintf(stderr, "Failed to get EGL version! Error: %s\n", eglGetErrorStr());
		eglTerminate(display);
		return EXIT_FAILURE;
	}

	EGLint numConfigs;
	EGLConfig config;
	if(!eglChooseConfig(display, configAttribs, &config, 1, &numConfigs)){
		fprintf(stderr, "Failed to get EGL config! Error: %s\n", eglGetErrorStr());
		eglTerminate(display);
		return EXIT_FAILURE;
	}

	EGLSurface surface = eglCreatePbufferSurface(display, config, pbufferAttribs);
	if(surface == EGL_NO_SURFACE){
		fprintf(stderr, "Failed to create EGL surface! Error: %s\n", eglGetErrorStr());
		eglTerminate(display);
		return EXIT_FAILURE;
	}

	eglBindAPI(EGL_OPENGL_API);

	EGLContext context = eglCreateContext(display, config, EGL_NO_CONTEXT, contextAttribs);
	if(context == EGL_NO_CONTEXT){
		fprintf(stderr, "Failed to create EGL context! Error: %s\n", eglGetErrorStr());
		eglDestroySurface(display, surface);
		eglTerminate(display);
		return EXIT_FAILURE;
	}

	eglMakeCurrent(display, surface, surface, context);

	// Create a shader program
	GLuint vert, frag;
	GLuint program = glCreateProgram();

	vert = glCreateShader(GL_VERTEX_SHADER);
	glShaderSource(vert, 1, &vertexShaderSource, NULL);
	glCompileShader(vert);

	frag = glCreateShader(GL_FRAGMENT_SHADER);
	glShaderSource(frag, 1, &fragmentShaderSource, NULL);
	glCompileShader(frag);

	glAttachShader(program, frag);
	glAttachShader(program, vert);
	glLinkProgram(program);

	glUseProgram(program);

	glClearColor(1.0f, 1.0f, 0.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	// create background-buffer
	unsigned int VBO, VAO, VFO, EBO;
	glGenVertexArrays(1, &VAO);
	glGenBuffers(1, &EBO);
	glBindVertexArray(VAO);

	glGenBuffers(1, &VBO);
	glBindBuffer(GL_ARRAY_BUFFER, VBO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices_back), vertices_back, GL_STATIC_DRAW);

	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void*)0);
	glEnableVertexAttribArray(0);

	glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void*)(3 * sizeof(float)));
	glEnableVertexAttribArray(1);

	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void*)(7 * sizeof(float)));
	glEnableVertexAttribArray(2);

	// Create background-texture
	GLuint texture_fore, texture_back;
	int checkImageWidth=1920;
	int checkImageHeight=1080;

        glGenTextures(1, &texture_back);
	glBindTexture(GL_TEXTURE_2D, texture_back);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, checkImageWidth, checkImageHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixeldata);

	// create foreground-buffer
	glBindVertexArray(VAO);
	glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);

	glGenBuffers(1, &VFO);
	glBindBuffer(GL_ARRAY_BUFFER, VFO);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices_fore), vertices_fore, GL_STATIC_DRAW);

	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void*)0);
	glEnableVertexAttribArray(0);

	glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void*)(3 * sizeof(float)));
	glEnableVertexAttribArray(1);

	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 9 * sizeof(float), (void*)(7 * sizeof(float)));
	glEnableVertexAttribArray(2);

	// Create foreground-texture
	glGenTextures(1, &texture_fore);
	glBindTexture(GL_TEXTURE_2D, texture_fore);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, checkImageWidth, checkImageHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixeldata);

	// render container
	glBindVertexArray(VAO);
	glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);

	unsigned int*p = (void *) m_FrameBuffer;
	glReadPixels(0, 0, m_VarInfo.xres, m_VarInfo.yres, GL_RGBA, GL_UNSIGNED_BYTE, p);

	// Cleanup
	eglDestroyContext(display, context);
	glDeleteVertexArrays(1, &VAO);
	glDeleteBuffers(1, &VFO);
	glDeleteBuffers(1, &VBO);
	glDeleteBuffers(1, &EBO);
	eglDestroySurface(display, surface);
	eglTerminate(display);
	return EXIT_SUCCESS;
}
// ------------------------------------------------------------------------

int main(int argc, char **argv) {

	struct dc_simple_post_config config;
	int iFrameBufferSize;
	uint32_t vPlanePhy;
	/* Open the framebuffer device in read write */
	m_FBFD = open(FB_NAME, O_RDWR);
	if (m_FBFD < 0) {
		printf("Unable to open %s.\n", FB_NAME);
		return 1;
	}
	/* Do Ioctl. Retrieve fixed screen info. */
	if (ioctl(m_FBFD, FBIOGET_FSCREENINFO, &m_FixInfo) < 0) {
		printf("get fixed screen info failed: %s\n",
				strerror(errno));
		close(m_FBFD);
		return 1;
	}
	/* Do Ioctl. Get the variable screen info. */
	if (ioctl(m_FBFD, FBIOGET_VSCREENINFO, &m_VarInfo) < 0) {
		printf("Unable to retrieve variable screen info: %s\n",
				strerror(errno));
		close(m_FBFD);
		return 1;
	}
	vPlanePhy=m_FixInfo.smem_start; //get PA from FB driver

	memset(&config, 0, sizeof(config));
	config.buf.sourceCrop.left=0;
	config.buf.sourceCrop.right=1920;
	config.buf.sourceCrop.top=0;
	config.buf.sourceCrop.bottom=1080;
	config.buf.displayFrame.left=0;
	config.buf.displayFrame.right=1920;
	config.buf.displayFrame.top=0;
	config.buf.displayFrame.bottom=1080;

	config.buf.width=m_VarInfo.xres;
	config.buf.height=m_VarInfo.yres;
	config.buf.stride=m_FixInfo.line_length;
	config.buf.id = eFrameBufferTarget;
	config.buf.overlay_engine = eEngine_VO;
	config.buf.acquire_fence_fd = -1;
	config.buf.phyAddr =  vPlanePhy; //set display buffer
	config.buf.colorkey = 0xff000000;   //format:ARGB, set -1 to disable color key
	config.buf.format = INBAND_CMD_GRAPHIC_FORMAT_ARGB8888_LITTLE;
	if (config.buf.format == INBAND_CMD_GRAPHIC_FORMAT_RGB565)
		config.buf.plane_alpha=ALPHA_VALUE; //plane alpha is available if pixel alpha is off

	/* Calculate the size to mmap */
	iFrameBufferSize = m_FixInfo.line_length * m_VarInfo.yres;
	printf("Line length %d %d %d %d\n", m_FixInfo.line_length, m_VarInfo.yres, m_VarInfo.xres,iFrameBufferSize);
	/* Now mmap the framebuffer. */
	m_FrameBuffer = mmap(NULL, iFrameBufferSize*2, PROT_READ | PROT_WRITE,
			MAP_SHARED, m_FBFD,0);
	if (m_FrameBuffer == NULL) {
		printf("mmap failed:\n");
		close(m_FBFD);
		return 1;
	}
	ioctl(m_FBFD, DC2VO_SIMPLE_POST_CONFIG, &config);
	{
		uint32_t *p = (void *) m_FrameBuffer;
		uint16_t x,y=0;
			for (y=0; y<m_VarInfo.yres; y++) {
				for (x=0; x<m_VarInfo.xres; x++) {
					if (y<(m_VarInfo.yres/2))
					p[x + y * m_VarInfo.xres] = 0xff888888;
					else
					p[x + y * m_VarInfo.xres] = 0xffffffff;
				}
			}
	 opengles_test();
         }
}
