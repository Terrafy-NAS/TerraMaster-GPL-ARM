/**
 * @file rtkcontrol.h
 * @author Realtek Semiconductor Corp.
 * @date Apr 2017
 * @brief File containing NVR APIs for controlling display, decoding, etc.
 */

#include <stdbool.h>

/**
 * @brief window identifier
 *
 * A window identifier (wnd) indicates a display window which shows media 
 * streams originated from a channel.
 */
typedef int WindowId;

/**
 * @brief channel identifier
 *
 * A channel identifier (ch) indicates a media channel which is used to, for 
 * example, decode media stream. To show the decoded stream in a display window,
 * a channel has to be bound to a window.
 */
typedef int ChannelId;

/**
 * @brief A structure describing the position and size of a window.
 *
 * The x and y describe the position of the window’s upper-left 
 * corner. The width and height describe the window size.
 */
typedef struct {
    unsigned int x;
    unsigned int y;
    unsigned int width;
    unsigned int height;
} WindowParams_t;

/**
 * @brief Audio codec.
 */
typedef enum {
    AUDIO_NONE = -1,
    AUDIO_AUTO,
    AUDIO_AAC,
    AUDIO_PCMU,
    AUDIO_PCMA,
    AUDIO_AMRNB,
    AUDIO_G726,
} AudioCodec_e;

/**
 * @brief Video codec.
 */
typedef enum {
    VIDEO_NONE = -1,
    VIDEO_AUTO,
    VIDEO_H264,
    VIDEO_H265,
    VIDEO_MJPEG,
} VideoCodec_e;

/**
 * @brief Return code.
 */
typedef enum {
    RTK_SUCCESS = 0,
    RTK_ERR_FAILURE = -1,
    RTK_ERR_INVALID_OPERATION = -2,
    RTK_ERR_INVALID_PARAM = -3,
    RTK_ERR_INSUFFICIENT_RESOURCE = -4,
} RtkReturn_e;

/**
 * @brief A structure describing the parameters of a media channel.
 */
typedef struct {
    unsigned int width;
    unsigned int height;
    AudioCodec_e aud_codec;
    int aud_samplerate;
    int aud_bitrate;
    int aud_channels;
    VideoCodec_e vid_codec;
    int vid_framerate;
    int vid_bitrate;
} ChannelParams_t;

/**
 * @brief HDMI resolution.
 */
typedef enum {
    HDMI_AUTO,
    HDMI_720P_50,
    HDMI_720P_60,
    HDMI_1080P_50,
    HDMI_1080P_60,
    HDMI_4K_30,
    HDMI_NONE,
} HDMIMode_e;


/**
 * @brief DP resolution.
 */
typedef enum {
    DP_AUTO,
    DP_720P_60,
    DP_1080P_60,
    DP_4K_30,
    DP_NONE,
} DPMode_e;

/**
 * @brief Channel state.
 */
typedef enum {
    CH_STATE_PLAY,
    CH_STATE_PAUSE,
    CH_STATE_STOP,
} ChannelState_e;

extern int debuglevel;

/**
 * @brief A function to initialize service communication.
 *
 * @return 0 on success, a negative error code on failure
 */
int rtk_serv_initialize(void);

/**
 * @brief A function to terminate service communication.
 *
 * @return 0 on success, a negative error code on failure
 */
int rtk_serv_terminate(void);

/**
 * @brief A function to create a window.
 *
 * @param x X axis of the position (the leftmost axis indicates 0)
 * @param y Y axis of the position (the topmost axis indicates 0)
 * @param width window width
 * @param height window height
 * @return window identifier on success, a negative value on failure
 */
WindowId rtk_disp_create(unsigned int x, unsigned int y,
			 unsigned int width, unsigned int height);

/**
 * @brief A function to destroy a window.
 *
 * @param wnd window identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_disp_destroy(WindowId wnd);

/**
 * @brief A function to get window parameters.
 *
 * @param wnd window identifier
 * @param param a structure containing the window parameters be returned
 * @return 0 on success, a negative error code on failure
 */
int rtk_disp_get_params(WindowId wnd, WindowParams_t * param);

/**
 * @brief A function to change window position and size.
 *
 * @param wnd window identifier
 * @param x X axis of the position (the leftmost axis indicates 0)
 * @param y Y axis of the position (the topmost axis indicates 0)
 * @param width window width
 * @param height window height
 * @return 0 on success, a negative error code on failure
 */
int rtk_disp_resize(WindowId wnd, unsigned int x, unsigned int y,
		    unsigned int width, unsigned int height);

/**
 * @brief A function to show the cropped area in a window.
 *
 * @param wnd window identifier
 * @param crop_x X axis of the cropped area
 * @param crop_y Y axis of the cropped area
 * @param crop_w width of the cropped area
 * @param crop_h height of the cropped area
 * @return 0 on success, a negative error code on failure
 */
int rtk_disp_crop(WindowId wnd, unsigned int crop_x, unsigned int crop_y,
		  unsigned int crop_w, unsigned int crop_h);

/**
 * @brief A function to set window blank.
 *
 * @param enable TRUE to set blank
 * @param num number of window identifiers. A variable number of arguments
 * indicates the window identifiers.
 * @return 0 on success, a negative error code on failure
 */
int rtk_disp_set_blank(bool enable, int num, ...);

/**
 * @brief A function to check if blank window.
 *
 * @param wnd window identifier
 * @param enabled blank or not
 * @return 0 on success, a negative error code on failure
 */
int rtk_disp_get_blank(WindowId wnd, bool * enabled);

/**
 * @brief A function to set output resolution.
 *
 * @param mode output resoultion
 * @return 0 on success, a negative error code on failure
 */
int rtk_disp_set_output(HDMIMode_e hdmiMode, DPMode_e dpMode);

/**
 * @brief A function to get output setting.
 *
 * @param mode the output mode be returned
 * @return 0 on success, a negative error code on failure
 */
int rtk_disp_get_output(HDMIMode_e * mode, DPMode_e * dpMode);

/**
 * @brief A function to add decoding channel.
 *
 * @return channel identifier on success, a negative value on failure
 */
ChannelId rtk_dec_add_channel(void);

/**
 * @brief A function to remove decoding channel.
 *
 * @param ch channel identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_remove_channel(ChannelId ch);

/**
 * @brief A function to get channel parameters.
 *
 * @param ch channel identifier
 * @param param a structure containing the channel parameters be returned
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_get_params(ChannelId ch, ChannelParams_t * param);

/**
 * @brief A function to bind a channel to a window.
 *
 * A channel has to be bound to a window for playing the stream in a display
 * window.
 *
 * @param ch channel identifier
 * @param wnd window identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_bind(ChannelId ch, WindowId wnd);

/**
 * @brief A function to set play state of a channel.
 *
 * @param state channel state
 * @param ch channel identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_set_play(ChannelState_e state, ChannelId ch);

/**
 * @brief A function to get play state of a channel.
 *
 * @param ch channel identifier
 * @param state the channel state be returned
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_get_play(ChannelId ch, ChannelState_e * state);

/**
 * @brief A function to seek on a channel.
 *
 * @param ch channel identifier
 * @param time position in seconds to seek to
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_seek(ChannelId ch, int time);

/**
 * @brief A function to change playback rate of a channel.
 *
 * @param ch channel identifier
 * @param rate playback rate
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_speed(ChannelId ch, int rate);

/**
 * @brief A function to open a file for a channel.
 *
 * @param ch channel identifier
 * @param filename the location of a file to open
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_open(ChannelId ch, const char *filename);

/**
 * @brief A function to play audio of a channel.
 *
 * @param ch channel identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_start_audio(ChannelId ch);

/**
 * @brief A function to stop playing audio of a channel.
 *
 * @param ch channel identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_stop_audio(ChannelId ch);

/**
 * @brief A function to set audio of a channel mute.
 *
 * @param enable TRUE to set mute
 * @param ch channel identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_set_mute(bool enable, ChannelId ch);

/**
 * @brief A function to set audio volume of a channel.
 *
 * @param volume to set audio volume : 0~10.0f
 * @param ch channel identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_set_volume(double volume, ChannelId ch);

/**
 * @brief A function to get audio volume of a channel.
 *
 * @param the channel volume be returned
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_get_volume(ChannelId ch, double *volume);

/**
 * @brief A function to increase audio volume of a channel.
 *
 * @param ch channel identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_increase_volume(ChannelId ch);

/**
 * @brief A function to decrease audio volume of a channel.
 *
 * @param ch channel identifier
 * @return 0 on success, a negative error code on failure
 */
int rtk_dec_decrease_volume(ChannelId ch);

/**
 * @brief A function to take a snapshot of the whole display.
 *
 * @param filename the location of the snapshot JPEG image file
 * @return 0 on success, a negative error code on failure
 */
int rtk_snapshot_display(const char *filename);

/**
 * @brief A function to write data to a channel.
 *
 * @param ch channel identifier
 * @param data the pointer to data.
 * The data must use MPEG-2 transport stream format with 188-byte packet size.
 * @param size size of data
 * @return the number of bytes written on success, a negative value on failure
 */
int rtk_buffer_write(ChannelId ch, void *data, int size);
